require 'rails_helper'

RSpec.describe PartyHtml, type: :model do
  describe 'associations' do
    it { should belong_to(:party) }
  end

  describe 'validations' do
    it { should validate_presence_of(:scraped_at) }
    it { should validate_presence_of(:html) }
  end
end
