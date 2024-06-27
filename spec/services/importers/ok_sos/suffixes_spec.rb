require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Suffixes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/suffixes.csv') }
    let(:record) { ::OkSos::Suffix.find_by!(suffix_id: 1) }
    let(:expected_attributes) do
      {
        suffix_id: 1,
        suffix: 'Sr'
      }
    end
  end
end
