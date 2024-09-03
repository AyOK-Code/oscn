require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::ValueDetails do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209111000') }
    let(:record) do
      OkAssessor::ValueDetail.find_by(account_id: account.id)
    end
    let(:expected_attributes) do
      {
        account_id: account.id,
        value_type: 'IMPROVED',
        abstract_code: '710L',
        abstract_code_description: 'City of Harrah',
        abstract_acres: 13.9506,
        abstract_square_feet: 21624,
        abstract_units: 1,
        tax_district: '107',
        abstract_assessed_value: 4681,
        abstract_account_value: 42553,
        status: 'A'
      }
    end
  end
end
