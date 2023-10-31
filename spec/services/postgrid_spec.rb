require 'rails_helper'

RSpec.describe Postgrid do
  let(:api_key) { 'fake_api_key' }
  let(:base_url) { 'https://api.postgrid.com/print-mail/v1' }
  let(:endpoint) { 'postcards' }
  let(:params) { { 'key' => 'value' } }
  let(:headers) { { 'x-api-key' => api_key } }
  let(:response_body) { { 'result' => 'success' }.to_json }

  before do
    allow(ENV).to receive(:fetch).with('POSTGRID_API_KEY').and_return(api_key)
  end

  describe '.get' do
    it 'makes a GET request to the Postgrid API' do
      stub_request(:get, "#{base_url}/#{endpoint}")
        .with(headers: headers, query: params)
        .to_return(status: 200, body: response_body)

      response = described_class.get(endpoint, params)

      expect(response.code).to eq(200)
      expect(response.body).to eq(response_body)
    end
  end

  describe '.post' do
    it 'makes a POST request to the Postgrid API' do
      stub_request(:post, "#{base_url}/#{endpoint}")
        .with(headers: headers, body: params)
        .to_return(status: 201, body: response_body)

      response = described_class.post(endpoint, params)

      expect(response.code).to eq(201)
      expect(response.body).to eq(response_body)
    end
  end

  describe '.delete' do
    it 'makes a DELETE request to the Postgrid API' do
      stub_request(:delete, "#{base_url}/#{endpoint}")
        .with(headers: headers, body: params)
        .to_return(status: 204, body: '')

      response = described_class.delete(endpoint, params)

      expect(response.code).to eq(204)
      expect(response.body).to eq(nil)
    end
  end
end
