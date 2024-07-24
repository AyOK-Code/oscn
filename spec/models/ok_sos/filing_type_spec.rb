require 'rails_helper'

RSpec.describe OkSos::FilingType, type: :model do
  describe 'associations' do
    it { should have_many(:corp_filings).class_name('OkSos::CorpFiling') }
  end

  describe 'validations' do
    it { should validate_presence_of(:filing_type_id) }
    it { should validate_presence_of(:description) }
  end
end
