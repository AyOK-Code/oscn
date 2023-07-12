require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::OneOffCase do
  describe '#perform' do
    context 'when the case has been searched before' do
      it 'does not send the request' do
        search = OscnScraper::Requestor::Search
        county = create(:county, name: 'Oklahoma')
        not_found = create(:case_not_found, county_id: county.id, case_number: 'CF-2022-123456')

        expect(search).not_to receive(:fetch_cases)
        described_class.perform('Oklahoma', not_found.case_number)
      end
    end
  end
end
