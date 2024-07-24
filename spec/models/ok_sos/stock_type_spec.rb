require 'rails_helper'

RSpec.describe OkSos::StockType, type: :model do
  describe 'associations' do
    it { should have_many(:stocks).class_name('OkSos::StockData') }
  end

  describe 'validations' do
    it { should validate_presence_of(:stock_type_id) }
    it { should validate_presence_of(:stock_type_description) }
  end
end
