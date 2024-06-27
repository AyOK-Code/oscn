require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Entities do
  it_behaves_like 'ok_sos_importer' do
    let!(:corp_type) { create(:ok_sos_corp_type, corp_type_id: 19) }
    let!(:entity_address) { create(:ok_sos_entity_address, address_id: 4_047_285) }
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/entities.csv') }
    let(:record) { ::OkSos::Entity.find_by!(filing_number: 3_513_036_711) }
    let(:expected_attributes) do
      {
        filing_number: 3_513_036_711,
        status_id: 20,
        external_corp_type_id: 19,
        external_address_id: 4_047_285,
        name: "MCGHEE''S TRASH REMOVAL & DEMOLITION SERVICE LLC",
        perpetual_flag: 1,
        creation_date: DateTime.parse('2021-12-09 00:00:00.000000000 -0600'),
        expiration_date: DateTime.parse('9999-12-31 00:00:00.000000000 -0600'),
        inactive_date: DateTime.parse('2023-02-08 00:00:00.000000000 -0600'),
        formation_date: nil,
        report_due_date: DateTime.parse('2022-07-01 00:00:00.000000000 -0500'),
        tax_id: nil,
        fictitious_name: '',
        foreign_fein: nil,
        foreign_state: '',
        foreign_country: '',
        foreign_formation_date: DateTime.parse('2021-12-09 00:00:00.000000000 -0600'),
        expiration_type: '7977',
        last_report_filed_date: nil,
        telno: '',
        otc_suspension_flag: 1,
        consent_name_flag: '0',
        corp_type_id: corp_type.id,
        entity_address_id: entity_address.id
      }
    end
  end
end
