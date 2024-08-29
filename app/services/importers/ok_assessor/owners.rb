require 'csv'

module Importers
  module OkAssessor
    class Owners < BaseImporter
      attr_reader :accounts

      def attributes(row)
        {
          account_id: accounts[row['ACCOUNT_NUM']],
          owner1:row['OWNER1'],
          owner2:row['OWNER2'],
          owner3:row['OWNER3'],
          mailing_address1:row['MAILING_ADDRESS1'],
          mailing_address2:row['MAILING_ADDRESS2'],
          mailing_address3:row['MAILING_ADDRESS3'],
          mailing_city:row['MAILING_CITY'],
          mailing_state:row['MAILING_STATE'],
          mailing_zipcode:row['MAILING_ZIPCODE'],
          primary_owner:row['PRIMARY_OWNER'],
          status:row['STATUS'],
          owner_change_date:parse_date(row['OWNER_CHANGE_DATE']),
          address_change_date:parse_date(row['ADDRESS_CHANGE_DATE']),
        }
      end

      def prefetch_associations
        @accounts = ::OkAssessor::Account.pluck(:account_num,:id).to_h
      end

      def model
        ::OkAssessor::Owner
      end

      def file_name
        'View_OKPublicRecordOwner.csv'
      end
    end
  end
end
