require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
  end

  context 'validations' do
    it { should validate_presence_of(:event_at) }
    it { should validate_presence_of(:event_type) }
  end
end
