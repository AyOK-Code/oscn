require 'csv'

module Importers
  module OkAssessor
    class Sales < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          grantor:row['GRANTOR'],
          grantee:row['GRANTEE'],
          sale_price:row['SALE_PRICE'],
          sale_date:row['SALE_DATE'],
          deed_type:row['DEED_TYPE'],
          valid_sale:row['VALID'],
          confirm:row['CONFIRM'],
          book:row['ACCOUNT_NUM_NO_PREFIX'],
          page:row['ACCOUNT_NUM_PREFIX'],
          revenue_stamps:row['BOOK'],
          change_date:row['PAGE'],
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num,:id).to_h
      end

      def model
        ::OkAssessor::Sale
      end

      def file_name
        'View_OKPublicRecordSale.csv'
      end
    end
  end
end
