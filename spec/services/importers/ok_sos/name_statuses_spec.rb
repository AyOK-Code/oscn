require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::NameStatuses do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/name_statuses.csv' }
    let(:record) { OkSos::NameStatus.find_by!(name_status_id: 1) }
    let(:expected_attributes) do
      {
        name_status_id: 1,
        name_status: 'In use'
      }
    end
  end
end
