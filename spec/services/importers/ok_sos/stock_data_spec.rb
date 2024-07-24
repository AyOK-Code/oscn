require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::StockData do
  it_behaves_like 'ok_sos_importer' do
    let!(:entity) { create(:ok_sos_entity, filing_number: 3_712_161_650) }
    let!(:stock_type) { create(:ok_sos_stock_type, stock_type_id: 1) }
    let(:sample_file) { 'spec/fixtures/importers/ok_sos/stock_data.csv' }
    let(:record) { OkSos::StockData.find_by!(stock_id: 1) }
    let(:expected_attributes) do
      {
        stock_id: 1,
        filing_number: 3_712_161_650,
        external_stock_type_id: 1,
        stock_series: nil,
        share_volume: 21_500_000,
        par_value: 1,
        entity_id: entity.id,
        stock_type_id: stock_type.id
      }
    end
  end
end
