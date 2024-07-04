require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::NameTypes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/name_types.csv' }
    let(:record) { ::OkSos::NameType.find_by!(name_type_id: 1) }
    let(:expected_attributes) do
      {
        name_type_id: 1,
        name_type: 'Legal'
      }
    end
  end
end
