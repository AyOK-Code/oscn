require 'csv'

module Importers
  module OkAssessor
    class SectionTownshipRanges < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          quarter: row['QUARTER'],
          section: row['SECTION'],
          township: row['TOWNSHIP'],
          range: row['RANGE']
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num, :id).to_h
      end

      def unique_by
        [:account_id]
      end

      def model
        ::OkAssessor::SectionTownshipRange
      end

      def file_name
        'View_OKPublicRecordSectionTownshipRange.csv'
      end
    end
  end
end
