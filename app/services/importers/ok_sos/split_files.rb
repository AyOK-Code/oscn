module Importers
  module OkSos
    class SplitFiles < ApplicationService
      attr_accessor :combined_zip_name
      PREFIX_FILE_MAP = {
        # 01~FILING_NUMBER~STATUS_ID~CORP_TYPE_ID~ADDRESS_ID~NAME~PERPETUAL_FLAG~CREATION_DATE~EXPIRATION_DATE~INACTIVE_DATE~FORMATION_DATE~REPORT_DUE_DATE~TAX_ID~FICTITIOUS_NAME~FOREIGN_FEIN~FOREIGN_STATE~FOREIGN_COUNTRY~FOREIGN_FORMATION_DATE~EXPIRATION_TYPE~LAST_REPORT_FILED_DATE~TELNO~OTC_SUSPENSION_FLAG~CONSENT_NAME_FLAG~
        "01": 'entities',
        # 02~ADDRESS_ID~ADDRESS1~ADDRESS2~CITY~STATE~ZIP_CODE~ZIP_EXTENSION~COUNTY~
        "02": 'entity_addresses',
        # 03~~BUSINESS_NAME~AGENT_LAST_NAME~AGENT_FIRST_NAME~AGENT_MIDDLE_NAME~CREATION_DATE~INACTIVE_DATE~NORMALIZED_NAME~SOS_RA_FLAG~
        "03": 'agents',  # FILING_NUMBER (entity id?)~ADDRESS_ID~AGENT_SUFFIX_ID
        # 04~FILING_NUMBER~OFFICER_ID~OFFICER_TITLE~BUSINESS_NAME~LAST_NAME~FIRST_NAME~MIDDLE_NAME~SUFFIX_ID~ADDRESS_ID~CREATION_DATE~INACTIVE_DATE~LAST_MODIFIED_DATE~NORMALIZED_NAME~
        "04": 'officers',
        # 05~FILING_NUMBER~NAME_ID~NAME~NAME_STATUS_ID~NAME_TYPE_ID~CREATION_DATE~INACTIVE_DATE~EXPIRE_DATE~ALL_COUNTIES_FLAG~CONSENT_FILING_NUMBER~SEARCH_ID~TRANSFER_TO~RECEIVED_FROM~
        "05": 'names',
        # 06~FILING_NUMBER~DOCUMENT_NUMBER~ASSOCIATED_ENTITY_ID~ ~PRIMARY_CAPACITY_ID~CAPACITY_ID~ASSOCIATED_ENTITY_NAME~ENTITY_FILING_NUMBER~ENTITY_FILING_DATE~INACTIVE_DATE~JURISDICTION_STATE~JURISDICTION_COUNTRY~
        "06": 'associated_entities',
        # 07~STOCK_ID~FILING_NUMBER~STOCK_TYPE_ID~STOCK_SERIES~SHARE_VOLUME~PAR_VALUE~
        "07": 'stock_data',
        # 08~FILING_NUMBER~QUALIFY_FLAG~UNLIMITED_FLAG~ACTUAL_AMT_INVESTED~PD_ON_CREDIT~TOT_AUTH_CAPITAL~
        "08": 'stock_infos',
        # 09~STOCK_TYPE_ID~STOCK_TYPE_DESC~
        "09": 'stock_types',
        # 10~FILING_TYPE_ID~FILING_TYPE~
        "10": 'filing_types',
        # 11~STATUS_ID~STATUS_DESCRIPTION~
        "11": 'corp_statuses',
        # 12~CORP_TYPE_ID~CORP_TYPE~
        "12": 'corp_types', #renamed to corp_type_description
        # 13~NAME_STATUS_ID~STATUS~
        "13": 'name_statuses',
        # 14~NAME_TYPE_ID~NAME_DESCRIPTION~
        "14": 'name_types',
        # 15~CAPACITY_ID~DESCRIPTION~
        "15": 'capacities',
        # 16~SUFFIX_ID~SUFFIX~
        "16": 'suffixes',
        # 17~FILING_NUMBER~DOCUMENT_NUMBER~FILING_TYPE_ID~FILING_TYPE~ENTRY_DATE~FILING_DATE~EFFECTIVE_DATE~EFFECTIVE_COND_FLAG~INACTIVE_DATE~
        "17": 'corp_filings',
        # 18~REFERENCE_NUMBER~AUDIT_DATE~TABLE_ID~FIELD_ID~PREVIOUS_VALUE~CURRENT_VALUE~ACTION~AUDIT_COMMENT~
        "18": 'audit_logs',
        "99": 'etc_error'
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
        line_count = `wc -l "#{@combined_file.path}"`.strip.split(' ')[0].to_i
        puts "Start time: #{Time.now}. Splitting csv. Combined csv line count is: #{line_count}"
        bar = ProgressBar.create(total: line_count, length: 160, format: '%a |%b>>%i| %p%% %t')
        File.new(@combined_file.path).each do |row_string|
          bar.increment
          row = row_string.strip.split('~')
          is_new_csv = !columns || columns[0] != row[0]
          if is_new_csv && merged_row.blank?
            if file_name.present?
              @csvs[file_name].close
            end
            columns = row.clone
            row = row.map(&:downcase)
            file_name = PREFIX_FILE_MAP[columns[0]]
            bar.log "Writing new file #{file_name}. First row: #{row_string}"
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
        row.map { |x| "\"#{x.gsub('"', '\"').squish}\"" }.join(',')+ "\n"
      end

      def folder_prefix
        combined_zip_name.gsub(".txt")
      end

      def download_combined_csv
        puts "Downloading combined csv zip file from aws."
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