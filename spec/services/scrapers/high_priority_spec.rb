require 'rails_helper'
require 'sidekiq/testing'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
Sidekiq::Testing.fake!

RSpec.describe Scrapers::HighPriority do
  before do
    ENV['CASE_TYPES_ABBREVIATION'] = 'CF'
  end
  describe '#perform' do
    let!(:case_type1) { create(:case_type, :felony) }
    # let!(:case_type2) { create(:case_type,name:'CIVIL RELIEF LESS THAN $10,000',abbreviation:'CS') }
    it 'add specs' do
      # do creates outside of test
      county = create(:county, name: 'Tulsa')

      create(:court_case, closed_on: 2.days.ago, county: county)
      response_body = File.read('spec/fixtures/Report.html')
      stub_request(:any, /oscn/).to_return(status: 200, body: response_body, headers: {})

      data = described_class.perform('Tulsa')
      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
      end
      expect(data.count).to eq 289
    end
  end
end
