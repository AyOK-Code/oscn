require 'rails_helper'

RSpec.describe PartyHtml do
  describe 'associations' do
    it { is_expected.to belong_to(:party) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:scraped_at) }
    it { is_expected.to validate_presence_of(:html) }
  end
end
