require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::ImprovementDetails do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209117010') }
    let!(:improvement) { create(:ok_assessor_improvement, building_num: 1, account: account) }
    let(:record) { OkAssessor::ImprovementDetail.find_by(improvement_id: improvement.id) }
    let(:expected_attributes) do
      {
        improvement_id: improvement.id,
        detail_type: 'BARN',
        detail_description: 'Barn, Wood, Pole and Metal',
        number_of_units: 2800,
        status: 'A'
      }
    end
  end
end
