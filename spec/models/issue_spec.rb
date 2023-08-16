require 'rails_helper'

RSpec.describe Issue do
  describe 'associations' do
    it { is_expected.to belong_to(:count_code) }
    it { is_expected.to belong_to(:court_case) }
    it { is_expected.to have_many(:issue_parties).dependent(:destroy) }
  end
end
