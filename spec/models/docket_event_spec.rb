require 'rails_helper'

describe DocketEvent, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:docket_event_type) }
    it { should belong_to(:party).optional }
  end

  context 'validations' do
    it { should validate_presence_of(:event_on) }
    it { should validate_presence_of(:description) }
  end
end
