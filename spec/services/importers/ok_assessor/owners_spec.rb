require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::Owners do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209111000') }
    let(:record) do
      OkAssessor::Owner.find_by(account_id: account.id)
    end
    let(:expected_attributes) do
      {
        account_id: account.id,
        owner1: 'CITY OF HARRAH',
        owner2: 'TORNEDEN BAUERS VALLAREE C',
        owner3: nil,
        mailing_address1: 'PO BOX 636',
        mailing_address2: 'PO BOX 112',
        mailing_address3: nil,
        mailing_city: 'HARRAH',
        mailing_state: 'OK',
        mailing_zipcode: '73045-0636',
        primary_owner: -1,
        status: 'A',
        owner_change_date: Date.parse('2019-01-30'),
        address_change_date: Date.parse('2019-01-30')
      }
    end
  end
end
