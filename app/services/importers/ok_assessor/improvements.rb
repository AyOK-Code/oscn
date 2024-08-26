require 'csv'

module Importers
  module OkAssessor
    class Improvements
      attr_reader :accounts

      def attributes(row)
        {
          account: row['ACCOUNT_NUM'],
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
