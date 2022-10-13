require 'rails_helper'

RSpec.describe Matchers::PartyNameSplitter do
  describe '#perform' do
    let!(:party) { create(:party, full_name: 'JONES,  EMILY') }
    it 'splits party name' do
      Matchers::PartyNameSplitter.new(party).perform
      expect(party.first_name).to eq('EMILY')
      expect(party.last_name).to eq('JONES')
    end
  end
end
