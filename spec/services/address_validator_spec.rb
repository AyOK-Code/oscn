require 'rails_helper'

RSpec.describe AddressValidator do
  let(:address) { '1234 Elm St' }
  let(:google_api_base_url) { 'https://addressvalidation.googleapis.com/v1:validateAddress?' }
  let(:response_body) { { 'validation_result' => 'success' }.to_json }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  before do
    allow(ENV).to receive(:fetch).with('GOOGLE_API_KEY').and_return('some_fake_api_key')
    stub_request(:post, "#{google_api_base_url}key=some_fake_api_key")
      .with(
        body: {
          'address' => {
            'regionCode' => 'US',
            'administrativeArea' => 'Oklahoma County',
            'addressLines' => [address]
          }
        }.to_json,
        headers: headers
      )
      .to_return(status: 200, body: response_body, headers: {})
  end

  describe '.perform' do
    it 'validates the address using Google API' do
      result = described_class.perform(address)

      expect(result.code).to eq(200)
      expect(result.body).to eq(response_body)
      expect(WebMock).to have_requested(:post, "#{google_api_base_url}key=some_fake_api_key")
        .with(
          body: {
            'address' => {
              'regionCode' => 'US',
              'administrativeArea' => 'Oklahoma County',
              'addressLines' => [address]
            }
          },
          headers: headers
        )
    end
  end
end
