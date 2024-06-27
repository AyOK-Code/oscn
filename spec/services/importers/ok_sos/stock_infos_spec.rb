require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::StockInfos do
  it_behaves_like 'ok_sos_importer' do
    let!(:entity) { create(:ok_sos_entity, filing_number: 3_513_037_087) }
    let(:sample_file) { File.read('spec/fixtures/importers/ok_sos/stock_infos.csv') }
    let(:record) { ::OkSos::StockInfo.find_by!(filing_number: 3_513_037_087) } # todo: update with real key
    let(:expected_attributes) do
      {
        filing_number: 3_513_037_087,
        qualify_flag: 0,
        unlimited_flag: 0,
        actual_amount_invested: 0,
        pd_on_credit: 0,
        tot_auth_capital: 0,
        entity_id: entity.id
      }
    end
  end
end
