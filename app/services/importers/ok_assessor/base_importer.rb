require 'csv'

module Importers
  module OkAssessor
    class BaseImporter < ApplicationService
      attr_accessor :dir

      def initialize(dir)
        @dir = dir
        prefetch_associations
      end

      def perform
        do_import
      end

      def do_import
        rows = []
        csv = CSV.parse(file, col_sep: '|', quote_char: '"', headers: true, liberal_parsing: true)
        row_count = csv.count
        bar = ProgressBar.new(row_count)
        csv.each_with_index do |row, i|
          bar.increment!
          rows << clean_attributes(row)
          if (i.present? && (i % 10_000).zero?) || i + 1 == row_count
            rows = check_and_fix_duplicates(rows)
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
        Bucket.new.get_object("ok_assessor/#{dir}/#{file_name}").body.read
      end

      def check_and_fix_duplicates(rows)
        grouped_rows = rows.group_by { |v| unique_by.map { |unique_key| v[unique_key] } }
        duplicates = grouped_rows.select { |_k, v| v.size > 1 }
        if duplicates.present?
          print "#{duplicates.count} duplicates found in batch. First duplicates (up to 20):"
          puts duplicates.values.flatten[0...20]

          if duplicates.count > 1000
            raise StandardError 'Too high a percentage of duplicates in batch. Check your unique keys'
          end
        end
        grouped_rows.values.map(&:first)
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
