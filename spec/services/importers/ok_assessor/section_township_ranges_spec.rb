require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::SectionTownshipRanges do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209111090') }
    let(:record) do
      OkAssessor::SectionTownshipRange.find_by(account_id: account.id)
    end
    let(:expected_attributes) do
      {
        account_id: account.id,
        quarter: 'NE',
        section: 1,
        township: '11N',
        range: '1E'
      }
    end
  end
end
