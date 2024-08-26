require 'csv'

module Importers
  module OkAssessor
    class ImprovementDetails
      attr_reader :accounts

      def attributes(row)
        {
          account: accounts[row['ACCOUNT_NUM']],
          building_num: row['BUILDING_NUM'],
          detail_type: row['DETAIL_TYPE'],
          detail_description: row['DETAIL_TYPE'],
          number_of_units: row['NUMBER_OF_UNITS'],
          status: row['STATUS']
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
