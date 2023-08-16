require 'rails_helper'

RSpec.describe PartyWorker, type: :worker do
  describe '#perform' do
    let(:oscn_id) { '5515773' }

    it 'imports party HTML and data, and updates the party status' do
      expect(::Importers::PartyHtml).to have_received(:perform).with(oscn_id)
      expect(::Importers::PartyData).to have_received(:perform).with(oscn_id)

      party = create(:party, oscn_id: oscn_id, enqueued: true)

      described_class.perform(oscn_id)
      expect(party.reload.enqueued).to be false
    end

    it 'raises an error when party is not found' do
      expect do
        described_class.perform(oscn_id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'is a Sidekiq worker' do
      expect(described_class).to include(Sidekiq::Worker)
    end

    it 'is a Sidekiq throttled worker' do
      expect(described_class).to include(Sidekiq::Throttled::Worker)
    end

    it 'has Sidekiq retry options set to 5' do
      expect(described_class.sidekiq_options['retry']).to eq(5)
    end
  end
end
