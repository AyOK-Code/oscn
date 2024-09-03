require 'csv'

module Importers
  module OkAssessor
    class ImprovementDetails < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          building_num: row['BUILDING_NUM'],
          detail_type: row['DETAIL_TYPE'],
          detail_description: row['DETAIL_DESCRIPTION'],
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

      def unique_by
        [:account_id, :building_num]
      end

      def file_name
        'View_OKPublicRecordImprovementDetail.csv'
      end
    end
  end
end
