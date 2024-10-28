require 'csv'

module Importers
  module OkAssessor
    class Accounts < BaseImporter
      # rubocop:disable Metrics/MethodLength
      def attributes
        {
          account_num: row['ACCOUNT_NUM'],
          parcel_num: row['PARCEL_NUM'],
          account_type: row['ACCOUNT_TYPE'],
          house_num: row['HOUSE_NUM'],
          direction: row['DIRECTION'],
          street_name: row['STREET_NAME'],
          street_suffix: row['STREET_SUFFIX'],
          unit: row['UNIT'],
          full_address: row['FULL_ADDRESS'],
          city: row['CITY'],
          zipcode: row['ZIPCODE'],
          business_name: row['BUSINESS_NAME'],
          map_number: row['MAP_NUMBER'],
          buildings: row['BUILDINGS'],
          full_legal: row['FULL_LEGAL'],
          land_ecomonic_area_id: row['LAND_ECOMONIC_AREA_ID'],
          land_ecomonic_area_description: row['LAND_ECOMONIC_AREA_DESCRIPTION'],
          subdivision_id: row['SUBDIVISION_ID'],
          subdivision_description: row['SUBDIVISION_DESCRIPTION'],
          land_total_acres: row['LAND_TOTAL_ACRES'],
          land_total_sq_foot: row['LAND_TOTAL_SQ_FOOT'],
          land_total_front_foot: row['LAND_TOTAL_FRONT_FOOT'],
          land_total_units: row['LAND_TOTAL_UNITS'],
          land_width: row['LAND_WIDTH'],
          land_depth: row['LAND_DEPTH'],
          vacant_land: row['VACANT_LAND'],
          platted_land: row['PLATTED_LAND'],
          tax_district: row['TAX_DISTRICT'],
          total_mill_levy: row['TOTAL_MILL_LEVY'],
          notice_of_valuation_value: row['NOTICE_OF_VALUATION_VALUE'],
          total_market_value: row['TOTAL_MARKET_VALUE'],
          total_taxable_value: row['TOTAL_TAXABLE_VALUE'],
          total_assessed_value: row['TOTAL_ASSESSED_VALUE'],
          adjusted_assessed_value: row['ADJUSTED_ASSESSED_VALUE'],
          last_doc_date: parse_date(row['LAST_DOC_DATE']),
          last_sale_date: parse_date(row['LAST_SALE_DATE']),
          legal_change_date: parse_date(row['LEGAL_CHANGE_DATE']),
          account_created_date: parse_date(row['ACCOUNT_CREATED_DATE']),
          account_deleted_date: parse_date(row['ACCOUNT_DELETED_DATE']),
          status: row['STATUS'],
          account_num_no_prefix: row['ACCOUNT_NUM_NO_PREFIX'],
          account_num_prefix: row['ACCOUNT_NUM_PREFIX'],
          parent_parcel_num: row['PARENT_PARCEL_NUM'],
          subdivision_lot_number: row['SUBDIVISION_LOT_NUMBER'],
          subdivision_block_number: row['SUBDIVISION_BLOCK_NUMBER'],
          account_change_date: parse_date(row['ACCOUNT_CHANGE_DATE']),
          adjustment_code: row['ADJUSTMENT_CODE'],
          adjustment_effective_year: row['ADJUSTMENT_EFFECTIVE_YEAR']
        }
      end
      # rubocop:enable Metrics/MethodLength

      def unique_by
        [:account_num]
      end

      def model
        ::OkAssessor::Account
      end

      def file_name
        'View_OKPublicRecordAccount.csv'
      end
    end
  end
end
