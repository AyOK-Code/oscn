require 'rails_helper'

RSpec.describe OkSos::CorpFiling, type: :model do
  describe 'associations' do
    it { should belong_to(:filing_type).class_name('OkSos::FilingType').optional }
    it { should belong_to(:entity).class_name('OkSos::Entity').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_number) }
    it { should validate_presence_of(:document_number) }
  end
end
