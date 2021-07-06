require 'rails_helper'

RSpec.describe DocketEvent, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:docket_event_type) }
    it { should belong_to(:party).optional }
    it { should have_one(:warrant).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:event_on) }
  end

  context 'scopes' do
    describe '#for_code' do
      it 'returns docket events of a certain code' do
        skip
      end
    end

    describe '#with_amount' do
      it '' do
        skip
      end
    end

    describe '#with_text' do
      it '' do
        skip
      end
    end
  end
end
