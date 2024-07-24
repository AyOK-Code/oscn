require 'rails_helper'

RSpec.describe OkSos::StockData, type: :model do
  describe 'associations' do
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
    it { should belong_to(:stock_type).class_name('OkSos::StockType') }
  end
end
