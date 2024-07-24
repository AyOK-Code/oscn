require 'rails_helper'

RSpec.describe OkSos::Entity, type: :model do
  describe 'associations' do
    it { should belong_to(:corp_type).class_name('OkSos::CorpType') }
    it { should belong_to(:corp_status).class_name('OkSos::CorpStatus').with_foreign_key('status_id').optional }
    it { should belong_to(:entity_address).class_name('OkSos::EntityAddress').optional }
    it { should have_many(:names).class_name('OkSos::Name') }
    it { should have_many(:officers).class_name('OkSos::Officer') }
    it { should have_many(:agents).class_name('OkSos::Agent') }
    it { should have_many(:associated_entities).class_name('OkSos::AssociatedEntity') }
    it { should have_many(:corp_filings).class_name('OkSos::CorpFiling') }
    it { should have_many(:stock_datas).class_name('OkSos::StockData') }
    it { should have_many(:stock_infos).class_name('OkSos::StockInfo') }
  end
end
