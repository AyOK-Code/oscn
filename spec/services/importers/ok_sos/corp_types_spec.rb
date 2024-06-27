require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::CorpTypes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/corp_types.csv') }
    let(:record) { ::OkSos::CorpType.find_by!(corp_type_id: 1) }
    let(:expected_attributes) {
      {
        :corp_type_id => 1,
        :corp_type_description => "Name Reservation",
      }
    }
  end
end
