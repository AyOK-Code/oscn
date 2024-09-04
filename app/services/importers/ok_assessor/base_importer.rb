require 'csv'

module Importers
  module OkAssessor
    class BaseImporter
      attr_accessor :dir

      def initialize(dir)
        @dir = dir
        prefetch_associations
      end

      def perform
        rows = []
        csv = CSV.parse(file, col_sep: '|', quote_char: '"', headers: true, liberal_parsing: true)
        row_count = csv.count
        bar = ProgressBar.new(row_count)
        csv.each_with_index do |row, i|
          bar.increment!
          rows << clean_attributes(row)
          if (i.present? && (i % 10_000).zero?) || i + 1 == row_count
            model.upsert_all(rows, unique_by: unique_by)
            rows = []
          end
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
        Date.strptime(date, '%m/%d/%Y')
      rescue StandardError => _e
        nil
      end

      def clean(field)
        return field unless field.instance_of? String

        field.strip.present? ? field.strip : nil
      end
    end
  end
end
