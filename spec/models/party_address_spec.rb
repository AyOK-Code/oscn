require 'rails_helper'

RSpec.describe PartyAddress do
  describe 'associations' do
    it { is_expected.to belong_to(:party) }
  end

  describe '.current' do
    it 'returns the current address' do
      address = create(:party_address, status: 'Current')
      create(:party_address)
      expect(described_class.current.size).to eq(1)
      expect(described_class.current.first.id).to eq(address.id)
    end
  end
end
