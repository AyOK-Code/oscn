require 'rails_helper'

RSpec.describe EvictionOcr::Mailer do
  let!(:eviction_letter) { create(:eviction_letter) }
  let(:mailer) { described_class.new(eviction_letter.id) }
  let(:postgrid_response) { { 'result' => { 'id' => 'some_id' } } }

  before do
    allow(ENV).to receive(:fetch).with('POSTGRID_API_KEY').and_return('fake_api_key')
    allow(Postgrid).to receive(:post).and_return(postgrid_response)
  end

  describe '.perform' do
    it 'updates the eviction letter status to mailed if successful' do
      described_class.perform

      expect(eviction_letter.status).to eq('mailed')
    end
  end

  describe '#create_postcard' do
    it 'creates a postcard and updates the eviction letter' do
      mailer.create_postcard

      expect(eviction_letter.postgrid_id).to eq('some_id')
      expect(eviction_letter.status).to eq('mailed')
    end
  end
end
