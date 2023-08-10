require 'rails_helper'

RSpec.describe CaseHtml do
  describe 'associations' do
    it { is_expected.to belong_to(:court_case) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:html) }
    it { is_expected.to validate_presence_of(:scraped_at) }
  end
end
