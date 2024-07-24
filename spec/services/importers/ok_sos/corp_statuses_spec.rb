require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::CorpStatuses do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/corp_statuses.csv' }
    let(:record) { OkSos::CorpStatus.find_by!(status_id: 1) }
    let(:expected_attributes) do
      {
        status_id: 1,
        status_description: 'In Existence'
      }
    end
  end
end
