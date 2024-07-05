require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::CorpFilings do
  it_behaves_like 'ok_sos_importer' do
    let!(:filing_type) { create(:ok_sos_filing_type, filing_type_id: 19_033) }
    let!(:entity) { create(:ok_sos_entity, filing_number: 3_513_036_711) }
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/corp_filings.csv' }
    let(:record) { OkSos::CorpFiling.find_by!(document_number: 52_158_420_002) } # TODO: replace with real id
    let(:expected_attributes) do
      {
        filing_number: 3_513_036_711,
        document_number: 52_158_420_002,
        external_filing_type_id: 19_033,
        external_filing_type: 'Articles of Organization',
        entry_date: DateTime.parse('2021-12-09'),
        filing_date: DateTime.parse('2021-12-09'),
        effective_date: DateTime.parse('2022-01-03'),
        effective_cond_flag: 0,
        inactive_date: nil,
        filing_type_id: filing_type.id,
        entity_id: entity.id
      }
    end
  end
end
