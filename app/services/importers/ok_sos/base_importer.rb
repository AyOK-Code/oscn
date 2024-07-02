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
        line_count = `wc -l "#{@file_path}"`.strip.split(' ')[0].to_i - 1
        bar = ProgressBar.create(total: line_count/10_000, length: 160, format: '%a |%b>>%i| %p%% %t') if line_count> 10_000
        CSV
          .foreach(file_path, col_sep: ',', quote_char:'"', headers: true, liberal_parsing: true) do |row|
          rows << attributes(row)
          if rows.count%10_000 == 0 || rows.count == line_count
            bar.increment if bar
            import_class.insert_all(rows)
            rows = []
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
        Date::strptime(date, '%m/%d/%Y')
      end

      def model_cache(klass, key)
        cache_key = klass.to_s
        return @model_cache[cache_key] if @model_cache[cache_key]

        @model_cache[cache_key] = klass.all.map{|x| [x[key].to_s, x]}.to_h
        @model_cache[cache_key]
      end

      def get_cached(klass, key, value, create: false)
        return nil unless value.present? && value != '0'

        return model_cache(klass, key)[value.to_s] if model_cache(klass, key)[value.to_s]

        raise ActiveRecord::RecordNotFound unless create

        new_model = klass.create!(key => value)
        @model_cache[klass.to_s][key.to_s] = new_model
        new_model
      end
    end
  end
end
