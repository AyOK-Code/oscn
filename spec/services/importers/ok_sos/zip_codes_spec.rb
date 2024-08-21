require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::ZipCodes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/entity_addresses.csv' }
    let(:record) { ZipCode.find_by(name: '73103') } # TODO: update this with real key?
    let(:expected_attributes) do
      {
        name: '73103'
      }
    end
  end
end
