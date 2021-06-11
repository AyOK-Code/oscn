require 'rails_helper'

RSpec.describe DocketEvent, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:docket_event_type) }
    it { should belong_to(:party).optional }
  end

  context 'validations' do
    it { should validate_presence_of(:event_on) }
    it { should validate_presence_of(:description) }
  end

  context 'scopes' do
    describe '#for_code' do
      it 'returns docket events of a certain code' do
        expect(true).to eq false
      end
    end
  end
end
