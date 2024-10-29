require 'csv'

module Importers
  module OkAssessor
    class Sales < BaseImporter
      attr_reader :accounts

      def attributes
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          reception_number: row['RECEPTION_NUM'],
          grantor: row['GRANTOR'],
          grantee: row['GRANTEE'],
          sale_price: row['SALE_PRICE'],
          sale_date: parse_date(row['SALE_DATE']),
          deed_type: row['DEED_TYPE'],
          valid_sale: row['VALID'],
          confirm: row['CONFIRM'],
          book: row['BOOK'],
          page: row['PAGE'],
          revenue_stamps: row['REVENUE_STAMPS'],
          change_date: parse_date(row['CHANGE_DATE'])
        }
      end

      def validate_attributes!
        raise AttributeError, "No account found for number: #{row['ACCOUNT_NUM']}" if attributes[:account_id].nil?
      end

      def unique_by
        [:account_id, :reception_number]
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num, :id).to_h
      end

      def model
        ::OkAssessor::Sale
      end

      def file_name
        'View_OKPublicRecordSales.csv'
      end
    end
  end
end
