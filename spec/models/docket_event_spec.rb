require 'rails_helper'

RSpec.describe DocketEvent, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:docket_event_type) }
    it { should belong_to(:party).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:event_on) }
  end

  describe 'scopes' do
    describe '#for_code' do
      it 'returns docket events of a certain code' do
        docket_event = create(:docket_event)
        docket_event.docket_event_type.code = 'SGDS'
        docket_event.docket_event_type.save
        docket_event2 = create(:docket_event, docket_event_type: docket_event.docket_event_type)
        expect(described_class.for_code('SGDS').size).to eq(2)
        expect(described_class.for_code('SGDS').pluck(:id)).to include(docket_event.id, docket_event2.id)
        # binding.pry
      end
    end

    describe '#without_amount' do
      it '' do
        create(:docket_event, amount: 200)
        docket_event = create(:docket_event, amount: 0)
        expect(described_class.without_amount.size).to eq(1)
        expect(described_class.without_amount.pluck(:id)).to include(docket_event.id)
      end
    end

    describe '#with_text' do
      it '' do
        docket_event = create(:docket_event, description: 'For Narnia!')
        create(:docket_event, description: nil)
        expect(described_class.with_text('Narnia').size).to eq(1)
        expect(described_class.with_text('Narnia').pluck(:id)).to include(docket_event.id)
      end
    end
  end
end
