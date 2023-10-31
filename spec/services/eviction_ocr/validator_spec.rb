require 'rails_helper'

RSpec.describe EvictionOcr::Validator do
  let!(:eviction_letter) { create(:eviction_letter, ocr_plaintiff_address: '123 Strawberry Lane') }
  let(:validator) { described_class.new(eviction_letter) }
  let(:address_validator_response) { double(code: 200, body: response_body) }

  let(:response_body) do
    {
      'result' => {
        'verdict' => {
          'validationGranularity' => 'high',
          'hasUnconfirmedComponents' => false,
          'hasInferredComponents' => true
        },
        'uspsData' => {
          'standardizedAddress' => {
            'firstAddressLine' => 'First Line',
            'cityStateZipAddressLine' => 'City, State, Zip'
          }
        },
        'address' => {
          'postalAddress' => {
            'addressLines' => ['Address Line 1'],
            'locality' => 'City',
            'administrativeArea' => 'State',
            'postalCode' => 'Zip'
          }
        },
        'geocode' => {
          'location' => {
            'latitude' => 40.7128,
            'longitude' => 74.0060
          }
        }
      }
    }.to_json
  end

  before do
    allow(AddressValidator).to receive(:perform).and_return(address_validator_response)
  end

  describe '.perform' do
    it 'calls AddressValidator with the correct parameters' do
      described_class.perform(eviction_letter.id)
      expect(AddressValidator).to have_received(:perform).with('123 Strawberry Lane')
    end

    it 'updates the eviction_letter when AddressValidator returns a 200' do
      described_class.perform(eviction_letter.id)
      eviction_letter.reload
      expect(eviction_letter.status).to eq('validated')
    end

    it 'does not update the eviction_letter when AddressValidator does not return a 200' do
      allow(address_validator_response).to receive(:code).and_return(404)
      expect_any_instance_of(EvictionLetter).not_to receive(:update)
      described_class.perform(eviction_letter.id)
    end
  end
end
