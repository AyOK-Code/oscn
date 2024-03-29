require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party).optional }
    it { should belong_to(:judge).optional }
    it { should belong_to(:event_type).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:event_at) }
  end
end
