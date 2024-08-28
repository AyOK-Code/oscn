require 'csv'

module Importers
  module OkAssessor
    class Improvements < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: row['ACCOUNT_NUM'],
          #..
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num, :id).to_h
      end

      def model
        ::OkAssessor::ImprovementDetail
      end

      def file_name
        'View_OKPublicRecordImprovement.csv'
      end
    end
  end
end
