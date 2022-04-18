require 'rails_helper'

RSpec.describe CaseHtml, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
  end

  describe 'validations' do
    it { should validate_presence_of(:html) }
    it { should validate_presence_of(:scraped_at) }
  end
end
