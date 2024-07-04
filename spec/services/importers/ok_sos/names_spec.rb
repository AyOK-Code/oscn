require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Names do
  it_behaves_like 'ok_sos_importer' do
    let!(:name_type) { create(:ok_sos_name_type, name_type_id: 1) }
    let!(:name_status) { create(:ok_sos_name_status, name_status_id: 3) }
    let!(:entity) { create(:ok_sos_entity, filing_number: 3_513_036_711) }
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/names.csv' }
    let(:record) { ::OkSos::Name.find_by!(name_id: 1) }
    let(:expected_attributes) do
      {
        filing_number: 3_513_036_711,
        name_id: 1,
        name: "MCGHEE'S TRASH REMOVAL & DEMOLITION SERVICE LLC",
        external_name_status_id: 3,
        external_name_type_id: 1,
        creation_date: DateTime.parse('2023-02-08 00:00:00.000000000 -0600'),
        inactive_date: DateTime.parse('2023-02-08 00:00:00.000000000 -0600'),
        expire_date: DateTime.parse('9999-12-31 00:00:00.000000000 -0600'),
        all_counties_flag: 'LIST',
        consent_filing_number: nil,
        search_id: 1,
        transfer_to: '',
        received_from: '',
        name_type_id: name_type.id,
        name_status_id: name_status.id,
        entity_id: entity.id
      }
    end
  end
end
