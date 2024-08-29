require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::Sales do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R206881000') }
    let(:record) do
      OkAssessor::Sale.find_by(account_id: account.id)
    end
    let(:expected_attributes) do
      {
        account_id: account.id,
        grantor: 'FALL CREEK DEVELOPMENT LLC',
        grantee: 'SHOOK KYLE J',
        sale_price: 150_000,
        sale_date: Date.parse('2018-10-25'),
        deed_type: 'Deeds',
        valid_sale: 'Valid',
        confirm: 'Confirmed',
        book: 13_873,
        page: 1593,
        revenue_stamps: 225.to_d,
        change_date: Date.parse('2018-10-30')
      }
    end
  end
end
