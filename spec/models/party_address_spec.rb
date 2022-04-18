require 'rails_helper'

RSpec.describe PartyAddress, type: :model do
  describe 'associations' do
    it { should belong_to(:party) }
  end

  describe '.current' do
    it 'returns the current address' do
      skip
    end
  end
end
