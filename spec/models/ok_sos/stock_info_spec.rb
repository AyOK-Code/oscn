require 'rails_helper'

RSpec.describe OkSos::StockInfo, type: :model do
  describe 'associations' do
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_number) }
  end
end
