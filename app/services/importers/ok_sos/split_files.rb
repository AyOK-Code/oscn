module Importers
  module OkSos
    class SplitFiles < ApplicationService
      attr_accessor :combined_zip_name

      PREFIX_FILE_MAP = {
        '01': 'entities',
        '02': 'entity_addresses',
        '03': 'agents',
        '04': 'officers',
        '05': 'names',
        '06': 'associated_entities',
        '07': 'stock_data',
        '08': 'stock_infos',
        '09': 'stock_types',
        '10': 'filing_types',
        '11': 'corp_statuses',
        '12': 'corp_types',
        '13': 'name_statuses',
        '14': 'name_types',
        '15': 'capacities',
        '16': 'suffixes',
        '17': 'corp_filings',
        '18': 'audit_logs',
        '99': 'etc_error'
      }.stringify_keys

      def initialize(combined_zip_name)
        @combined_zip_name = combined_zip_name
        @combined_file = nil
        @csvs = {}
      end

      def perform
        download_combined_csv
        split_files
        import_files
      end

      def import_files
        [
          :audit_logs,
          :capacities,
          :corp_statuses,
          :corp_types,
          :filing_types,
          :entity_addresses,
          :name_statuses,
          :name_types,
          :suffixes,
          :stock_types,
          :entities,
          :corp_filings,
          :names,
          :stock_data,
          :stock_infos,
          :agents,
          :associated_entities,
          :officers
        ].each do |file|
          klass = Object.const_get("::Importers::OkSos::#{file.to_s.classify.pluralize}")
          puts "importing #{klass}"
          klass.perform(@csvs[file.to_s].path)
        end
      end

      def split_files
        columns = nil
        file_name = ''
        merged_row = '' # multiple rows may need to get merged if there is a \r or \n in a string column
        line_count = `wc -l "#{@combined_file.path}"`.strip.split[0].to_i
        puts "Start time: #{Time.now}. Splitting csv. Combined csv line count is: #{line_count}"
        bar = ProgressBar.new(line_count)
        File.new(@combined_file.path).each do |row_string|
          bar.increment!
          row = row_string.strip.split('~')
          is_new_csv = !columns || columns[0] != row[0]
          if is_new_csv && merged_row.blank?
            @csvs[file_name].close if file_name.present?
            columns = row.clone
            row = row.map(&:downcase)
            file_name = PREFIX_FILE_MAP[columns[0]]
            Rails.logger.info "Writing new file #{file_name}. First row: #{row_string}"
            @csvs[file_name] = Tempfile.new("#{file_name}.csv")
          elsif columns.length > row.length
            row_string = row_string.delete("\n").delete("\r")
            merged_row += row_string
            row = merged_row.split('~')
            is_complete_row = columns.length == row.length
            next unless is_complete_row
          end
          formatted_row = format_row(row)
          @csvs[file_name].write(formatted_row)
          merged_row = ''
        end
        puts "CSV splitting complete. End time: #{Time.now}"
      end

      def format_row(row)
        row.delete_at(0)
        quoted_row = row.map { |x| "\"#{x.gsub('"', '\"').squish}\"" }
        "#{quoted_row.join(',')}\n"
      end

      def folder_prefix
        combined_zip_name.gsub('.txt')
      end

      def download_combined_csv
        puts 'Downloading combined csv zip file from aws.'
        response = Bucket.new.get_object("ok_sos/#{combined_zip_name}")
        Zip::InputStream.open(response.body) do |io|
          io.get_next_entry
          @combined_file = Tempfile.new(combined_zip_name)
          @combined_file.write(io.read.encode('UTF-8', invalid: :replace, undef: :replace))
          @combined_file.close
        end
      end
    end
  end
end
