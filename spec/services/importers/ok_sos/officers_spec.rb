require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Officers do
  it_behaves_like 'ok_sos_importer' do
    let!(:entity_address) { create(:ok_sos_entity_address, address_id: 3904005)}
    let!(:entity) { create(:ok_sos_entity, filing_number: 3512964051)}
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/officers.csv') }
    let(:record) { ::OkSos::Officer.find_by!(officer_id: 1) }
    let(:expected_attributes) do
      {
        filing_number: 3512964051,
        officer_id: 1,
        officer_title: 'INCORPORATOR',
        business_name: '',
        last_name: 'QUINTON',
        first_name: 'V KEITH',
        middle_name: '',
        external_suffix_id: 0,
        external_address_id: 3904005,
        creation_date: DateTime.parse('2021-06-01 00:00:00.000000000 -0500'),
        inactive_date: nil,
        last_modified_date: DateTime.parse('2021-06-01 00:00:00.000000000 -0500'),
        normalized_name: '',
        entity_address_id: entity_address.id,
        entity_id: entity.id,
        suffix_id: nil
      }
    end
  end
end
