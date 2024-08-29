require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::LandAttributes do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209111000') }
    let(:record) do
      OkAssessor::LandAttribute.find_by(account_id: account.id)
    end
    let(:expected_attributes) do
      {
        account_id: account.id,
        attribute_type: 'Street',
        attribute_description: 'Curb Cut (1)',
        attribute_adjustment: 0.0,
        status: 'A'
      }
    end
  end
end
