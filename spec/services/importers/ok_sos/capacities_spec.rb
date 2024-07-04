require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::Capacities do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/capacities.csv' }
    let(:record) { ::OkSos::Capacity.find_by!(capacity_id: 1) }
    let(:expected_attributes) {
      {
        :capacity_id => 1,
        :description => "Survivor",
      }
    }
  end
end
