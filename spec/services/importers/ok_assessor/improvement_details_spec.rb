require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::ImprovementDetails do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209117010') }
    let(:record) { OkAssessor::ImprovementDetail.find_by(account_id: account.id, building_num: 1) }
    let(:expected_attributes) do
      {
        account_id: account.id,
        building_num: 1,
        detail_type: nil,
        detail_description: 'Canopy Walkway Unfinished',
        number_of_units: 2800,
        status: 'A',
      }
    end
  end
end
