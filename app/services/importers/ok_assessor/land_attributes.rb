require 'csv'

module Importers
  module OkAssessor
    class LandAttributes < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          attribute_type:row['ATTRIBUTE_TYPE'],
          attribute_description:row['ATTRIBUTE_DESCRIPTION'],
          attribute_adjustment:row['ATTRIBUTE_ADJUSTMENT'],
          status:row['STATUS'],
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num,:id).to_h
      end

      def model
        ::OkAssessor::LandAttribute
      end

      def file_name
        'View_OKPublicRecordLandAttributes.csv'
      end
    end
  end
end
