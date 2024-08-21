require 'csv'

module Importers
  module OkSos
    class BaseImporter < ApplicationService
      attr_accessor :file_path

      BATCH_SIZE = 10_000

      def initialize(file_path)
        @file_path = file_path
        @@model_cache = ActiveSupport::HashWithIndifferentAccess.new({})
        super()
      end

      def perform
        do_import
      end

      def do_import
        puts "importing csv in batches of #{BATCH_SIZE}"
        rows = []
        error_rows = []
        row_count = File.read(file_path).strip.scan("\n").length
        if row_count > BATCH_SIZE
          bar = ProgressBar.new(row_count / BATCH_SIZE)
        end
        CSV
          .foreach(file_path, col_sep: ',', quote_char: '"', headers: true, liberal_parsing: true) do |row|
          begin
            rows << attributes(row)
          rescue StandardError => e
            error_rows << { row: row, e: e }
          end
          total_rows = (rows + error_rows).count
          if (total_rows % BATCH_SIZE).zero? || total_rows == row_count
            rows = check_and_fix_duplicates(rows)
            bar&.increment!
            import_class.upsert_all(rows, unique_by: unique_by)
            rows = []
            error_rows = []
          end
        end
        nil unless error_rows.present?
      end

      def check_and_fix_duplicates(rows)
        grouped_rows = rows.group_by { |v| unique_by.map { |unique_key| v[unique_key] } }
        duplicates = grouped_rows.select { |_k, v| v.size > 1 }
        if duplicates.present?
          print "#{duplicates.count} duplicates found in batch. First duplicates (up to 20):"
          puts duplicates.values.flatten[0...20]

          if !ignore_duplicates && duplicates.count > BATCH_SIZE * 0.05
            raise StandardError 'Too high a percentage of duplicates in batch. Check your unique keys'
          end

          puts 'Inserting first values.'
        end
        grouped_rows.values.map(&:first)
      end

      def print_errors(error_rows)
        puts "#{error_rows.count} errors in batch. First errors (up to 10):"
        puts error_rows[0...10]
      end

      def import_type
        self.class.name.demodulize.underscore
      end

      def import_class
        klass_name = "::OkSos::#{self.class.name.demodulize.singularize}"
        Object.const_get(klass_name)
      end

      def parse_date(date)
        nil_dates = ['00/00/0000']
        return nil if nil_dates.include? date

        begin
          Date.strptime(date, '%m/%d/%Y')
        rescue StandardError => _e
          nil
        end
      end

      def model_cache(klass, key)
        klass_key = klass.to_s
        return @@model_cache[klass_key] if @@model_cache[klass_key]

        @@model_cache[klass_key] = klass.pluck(key, :id).to_h { |x| [x[0].to_s, x[1]] }
        @@model_cache[klass_key]
      end

      def get_cached(klass, key, value, create: false)
        return nil unless value.present? && value != '0'

        return model_cache(klass, key)[value.to_s] if model_cache(klass, key)[value.to_s]

        raise ActiveRecord::RecordNotFound unless create

        new_model = klass.create!(key => value)
        @@model_cache[klass.to_s][value.to_s] = new_model.id
        new_model.id
      end

      def ignore_duplicates
        false
      end
    end
  end
end
