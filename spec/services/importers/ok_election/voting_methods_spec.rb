require 'rails_helper'

RSpec.describe Importers::OkElection::VotingMethods do
  describe 'perform' do
    it 'imports the voting methods data' do
      described_class.perform
      expect(OkElection::VotingMethod.count).to eq(9)
    end

    it 'does not import duplicate voting methods' do
      described_class.perform
      described_class.perform
      expect(OkElection::VotingMethod.count).to eq(9)
    end
  end
end
