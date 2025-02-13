require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::Accounts do
  it_behaves_like 'ok_assessor_importer' do
    let(:record) { OkAssessor::Account.find_by(account_num: 'R209117010') }
    let(:expected_attributes) do
      {
        account_num: 'R209117010',
        parcel_num: 1_001_209_117_010,
        account_type: 'Exempt',
        house_num: 8140,
        direction: 'NW',
        street_name: '30TH',
        street_suffix: 'TER',
        unit: '1/2',
        full_address: '8342 NW 30TH TER',
        city: 'BETHANY',
        zipcode: '73008',
        business_name: nil,
        map_number: 1001,
        buildings: 0,
        full_legal: 'HARRAH INDUSTRIAL PARK 001 002',
        land_ecomonic_area_id: '1701',
        land_ecomonic_area_description: 'CM IND POTT',
        subdivision_id: 20_911,
        subdivision_description: 'HARRAH INDUSTRIAL PARK',
        land_total_acres: 7.3462.to_d,
        land_total_sq_foot: 320_000.to_d,
        land_total_front_foot: nil,
        land_total_units: nil,
        land_width: 142.to_d,
        land_depth: 163.to_d,
        vacant_land: -1,
        platted_land: nil,
        tax_district: '107',
        total_mill_levy: 102.0400,
        notice_of_valuation_value: 8053,
        total_market_value: 95_000,
        total_taxable_value: 7053,
        total_assessed_value: 17_985,
        adjusted_assessed_value: 10_450,
        last_doc_date: Date.parse('2000-10-30'),
        last_sale_date: Date.parse('2019-01-17'),
        legal_change_date: Date.parse('2019-03-09'),
        account_created_date: Date.parse('2017-09-28'),
        account_deleted_date: nil,
        status: 'A',
        account_num_no_prefix: 209_117_010,
        account_num_prefix: 'R',
        parent_parcel_num: nil,
        subdivision_lot_number: '002',
        subdivision_block_number: '001',
        account_change_date: Date.parse('2019-01-30'),
        adjustment_code: 500,
        adjustment_effective_year: 2016
      }
    end
  end
end
