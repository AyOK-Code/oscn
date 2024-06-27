require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Agents do
  it_behaves_like 'ok_sos_importer' do
    let!(:address) { create(:ok_sos_entity_address, address_id: 4047286) }
    let!(:entity) { create(:ok_sos_entity, filing_number: 3513036711) }
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/agents.csv') }
    let(:record) { OkSos::Agent.find_by(filing_number: 3513036711) } # todo: update this with real key?
    let(:expected_attributes) {
      {
        :filing_number => 3513036711,
        :external_address_id => 4047286,
        :business_name => "",
        :agent_last_name => "MCGHEE",
        :agent_first_name => "WILLIAM",
        :agent_middle_name => "",
        :agent_suffix_id => "0",
        :creation_date => DateTime.parse("2021-12-09 00:00:00.000000000 -0600"),
        :inactive_date => nil,
        :normalized_name => "",
        :sos_ra_flag => 0,
        :entity_address_id => address.id,
        :suffix_id => nil,
        :entity_id => entity.id
      }
    }
  end
end
