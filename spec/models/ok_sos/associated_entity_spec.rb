require 'rails_helper'

RSpec.describe OkSos::AssociatedEntity, type: :model do
  describe 'associations' do
    it { should belong_to(:capacity).class_name('OkSos::Capacity') }
    it { should belong_to(:corp_type).class_name('OkSos::CorpType').optional }
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_number) }
  end
end
