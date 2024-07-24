require 'rails_helper'

RSpec.describe OkSos::Name, type: :model do
  describe 'associations' do
    it { should belong_to(:name_type).class_name('OkSos::NameType').optional }
    it { should belong_to(:name_status).class_name('OkSos::NameStatus').optional }
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_number) }
  end
end
