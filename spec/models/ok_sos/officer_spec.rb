require 'rails_helper'

RSpec.describe OkSos::Officer, type: :model do
  describe 'associations' do
    it { should belong_to(:entity_address).class_name('OkSos::EntityAddress').optional }
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
    it { should belong_to(:suffix).class_name('OkSos::Suffix').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_number) }
  end
end
