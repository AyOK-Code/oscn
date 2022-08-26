require 'rails_helper'
RSpec.describe Importers::CaseHtml do
  describe '#perform' do
    let(:county) { create(:county, name: 'tulsa') }
    let(:court_case) { create(:court_case, county_id: county.id, case_number: 'CF-2018-1016') }
    it 'raises the captcha error' do
      request_url = 'https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2016-0' # can I evem use this since this is the base class?
      response_body = File.read('spec/fixtures/captcha.html')
      stub_request(:get, request_url)
        .to_return(status: 200, body: response_body, headers: {})

      expect { described_class.perform(county.id, 'CF-2016-0') }.to raise_error OscnScraper::Errors::Captcha
    end
  end
end
