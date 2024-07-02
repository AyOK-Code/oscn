require 'rails_helper'
require 'services/importers/ok_sos/shared_specs'

RSpec.describe Importers::OkSos::StockTypes do
  it_behaves_like 'ok_sos_importer' do
    let(:sample_file) {'spec/fixtures/importers/ok_sos/stock_types.csv' }
    let(:record) { ::OkSos::StockType.find_by!(stock_type_id: 1) }
    let(:expected_attributes) do
      {
        stock_type_id: 1,
        stock_type_description: 'Common (Voting)'
      }
    end
  end
end
