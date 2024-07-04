require 'csv'

module Importers
  module OkSos
    class BaseImporter < ApplicationService
      attr_accessor :file_path

      def initialize(file_path)
        @file_path = file_path
        @model_cache = ActiveSupport::HashWithIndifferentAccess.new({})
      end

      def perform
        do_import
      end

      def do_import
        puts 'importing csv in batches'
        rows = []
        error_rows = []
        line_count = `wc -l "#{@file_path}"`.strip.split[0].to_i - 1
        if line_count > 10_000
          bar = ProgressBar.create(total: line_count / 10_000, length: 160,
                                   format: '%a |%b>>%i| %p%% %t')
        end
        CSV
          .foreach(file_path, col_sep: ',', quote_char: '"', headers: true, liberal_parsing: true) do |row|
          begin
            rows << attributes(row)
          rescue StandardError => e
            error_rows << { row: row, e: e }
          end
          if ((rows + error_rows).count % 10_000).zero? || rows.count == line_count
            bar&.increment
            import_class.upsert_all(rows, unique_by: unique_by)
            rows = []
          end
        end
        return unless error_rows.present?

        puts "#{error_rows.count} errors."
        puts 'first errors (up to 10):'
        error_rows[0..10].each do |error_row|
          error_row.each do |k, v|
            puts "#{k}: #{v}"
          end
        end
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
        cache_key = klass.to_s
        return @model_cache[cache_key] if @model_cache[cache_key]

        @model_cache[cache_key] = klass.all.to_h { |x| [x[key].to_s, x] }
        @model_cache[cache_key]
      end

      def get_cached(klass, key, value, create: false)
        return nil unless value.present? && value != '0'

        return model_cache(klass, key)[value.to_s] if model_cache(klass, key)[value.to_s]

        raise ActiveRecord::RecordNotFound unless create

        new_model = klass.create!(key => value)
        @model_cache[klass.to_s][value.to_s] = new_model
        new_model
      end
    end
  end
end
