require 'rails_helper'

RSpec.describe EvictionOcr::Run do
  let(:eviction_letter) { create(:eviction_letter) }
  let(:run) { described_class.new(eviction_letter.id) }

  before do
    allow(EvictionOcr::Extractor).to receive(:perform)
    allow(EvictionOcr::Validator).to receive(:perform)
    allow(EvictionOcr::Mailer).to receive(:perform)
    allow(Raygun).to receive(:track_exception)
  end

  describe '.perform' do
    it 'invokes the perform methods of each action class' do
      described_class.perform(eviction_letter.id)
      
      expect(EvictionOcr::Extractor).to have_received(:perform).with(eviction_letter.id)
      expect(EvictionOcr::Validator).to have_received(:perform).with(eviction_letter.id)
      expect(EvictionOcr::Mailer).to have_received(:perform).with(eviction_letter.id)
    end

    it 'tracks exceptions with Raygun' do
      allow(EvictionOcr::Extractor).to receive(:perform).and_raise(StandardError.new('Test Error'))

      described_class.perform(eviction_letter.id)

      expect(Raygun).to have_received(:track_exception).with(instance_of(StandardError))
    end
  end
end
