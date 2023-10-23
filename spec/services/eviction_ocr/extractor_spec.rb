require 'rails_helper'

RSpec.describe EvictionOcr::Extractor do
  let(:eviction_letter) { create(:eviction_letter) }
  let(:extractor) { described_class.new(eviction_letter.id) }
  let(:result_data) do
    {
      'plaintiff_address' => '123 Street',
      'agreed_amount' => '1000',
      'default_amount' => '2000',
      'plaintiff_phone_number' => '555-5555'
    }
  end

  before do
    allow(ENV).to receive(:fetch).with('AZURE_FORM_API_KEY').and_return('fake_api_key')
    allow(AzureCustomExtractor).to receive(:perform).and_return(result_data)
  end

  describe '.perform' do
    it 'updates the eviction letter' do
      described_class.perform(eviction_letter.id)
      eviction_letter.reload
      expect(eviction_letter.status).to eq('extracted')
      expect(eviction_letter.ocr_plaintiff_address).to eq(result_data['plaintiff_address'])
      expect(eviction_letter.ocr_agreed_amount).to eq(result_data['agreed_amount'])
      expect(eviction_letter.ocr_default_amount).to eq(result_data['default_amount'])
      expect(eviction_letter.ocr_plaintiff_phone_number).to eq(result_data['plaintiff_phone_number'])
    end
  end
end
