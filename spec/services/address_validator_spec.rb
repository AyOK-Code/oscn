# Test Google Maps API

# Path: spec/services/address_validator_spec.rb
# require 'rails_helper'

RSpec.describe AddressValidator do
  describe '#perform' do
    # Mock API call to Google Maps API
    it 'returns a 200 response' do
      VCR.use_cassette('google_maps_api') do
        response = AddressValidator.perform('123 Main St, Oklahoma City, OK 73102')
        expect(response.code.to_i).to eq(200)
      end
    end
  end
end

