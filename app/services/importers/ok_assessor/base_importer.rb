require 'csv'

module Importers
  module OkAssessor
    class Accounts
      def initialize
        prefetch_associations
      end

      def perform
        CSV.parse(file, col_sep: '|', quote_char: '"', headers: true, liberal_parsing: true) do |row|
          model.upsert(attributes(row))
        end
      end

      def prefetch_associations; end

      def file
        Bucket.new.get_object("ok_assessor/#{file_name}").body.read
      end
    end
  end
end
