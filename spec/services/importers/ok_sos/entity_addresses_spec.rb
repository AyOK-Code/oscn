require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::EntityAddresses do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/entity_addresses.csv') }
    let(:record) { ::OkSos::EntityAddress.find_by!(address_id: 10) }
    let(:expected_attributes) do
      {
        address_id: 10,
        address1: '421 NW 13th St, Suite 210',
        address2: '',
        city: 'OKLAHOMA CITY',
        state: 'OK',
        zip_string: '73103',
        zip_extension: nil,
        country: 'USA',
        zip_code_id: ::ZipCode.find_by(name: 73_103)
      }
    end
  end
end
