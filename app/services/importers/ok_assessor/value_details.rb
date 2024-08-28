require 'csv'

module Importers
  module OkAssessor
    class ValueDetails < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          value_type: row['VALUE_TYPE'],
          abstract_code: row['ABSTRACT_CODE'],
          abstract_code_description: row['ABSTRACT_CODE_DESCRIPTION'],
          abstract_acres: row['ABSTRACT_ACRES'],
          abstract_square_feet: row['ABSTRACT_SQUARE_FEET'],
          abstract_units: row['ABSTRACT_UNITS'],
          tax_district: row['TAX_DISTRICT'],
          abstract_assessed_value: row['ABSTRACT_ASSESSED_VALUE'],
          abstract_account_value: row['ABSTRACT_ACCOUNT_VALUE'],
          status: row['STATUS'],
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num, :id).to_h
      end

      def model
        ::OkAssessor::ValueDetail
      end

      def file_name
        'View_OKPublicValueDetail.csv'
      end
    end
  end
end
