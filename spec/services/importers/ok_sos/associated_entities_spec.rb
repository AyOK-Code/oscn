require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::AssociatedEntities do
  it_behaves_like 'ok_sos_importer' do
    let!(:capacity) { create(:ok_sos_capacity, capacity_id: 1) }
    let!(:entity) { create(:ok_sos_entity, filing_number: 3_512_995_133) }
    let!(:corp_type) { create(:ok_sos_corp_type, corp_type_id: 13) }
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/associated_entities.csv' }
    let(:record) { OkSos::AssociatedEntity.find_by!(filing_number: 3_512_995_133) } # TODO: update this with real key?
    let(:expected_attributes) do
      {
        filing_number: 3_512_995_133,
        document_number: 55_778_210_001,
        associated_entity_id: 1,
        associated_entity_corp_type_id: 13,
        primary_capacity_id: 2,
        external_capacity_id: 1,
        associated_entity_name: 'PROMPTI, INC.',
        entity_filing_number: 999_999_999, # TODO: is this typically valid entity?
        entity_filing_date: DateTime.parse('2022-08-05'),
        inactive_date: nil,
        jurisdiction_state: 'DE',
        jurisdiction_country: 'USA',
        capacity_id: capacity.id,
        corp_type_id: corp_type.id
      }
    end
  end
end
