require 'rails_helper'

RSpec.describe Event do
  describe 'associations' do
    it { is_expected.to belong_to(:court_case) }
    it { is_expected.to belong_to(:party).optional }
    it { is_expected.to belong_to(:judge).optional }
    it { is_expected.to belong_to(:event_type).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:event_at) }
  end
end
