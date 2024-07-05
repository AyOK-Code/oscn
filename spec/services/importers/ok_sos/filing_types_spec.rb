require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::FilingTypes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/filing_types.csv' }
    let(:record) { OkSos::FilingType.find_by!(filing_type_id: 3027) }
    let(:expected_attributes) do
      {
        filing_type_id: 3027,
        filing_type: 'Certificate of Amendment (Prior To Effective Date)'
      }
    end
  end
end
