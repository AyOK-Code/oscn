require 'csv'

module Importers
  module OkAssessor
    class BaseImporter
      def initialize
        prefetch_associations
      end

      def perform
        CSV.parse(file, col_sep: '|', quote_char: '"', headers: true, liberal_parsing: true) do |row|
          model.upsert(clean_attributes(row))
        end
      end

      def clean_attributes(row)
        attributes(row).transform_values do |v|
          clean(v)
        end
      end

      def prefetch_associations; end

      def file
        Bucket.new.get_object("ok_assessor/#{file_name}").body.read
      end

      def parse_date(date)
        begin
          Date.strptime(date, '%m/%d/%Y')
        rescue StandardError => _e
          nil
        end
      end

      def clean(field)
        return field unless field.instance_of? String

        field.strip.present? ? field.strip : nil
      end
    end
  end
end
