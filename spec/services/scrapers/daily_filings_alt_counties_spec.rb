require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::DailyFilingsAltCounties do
  describe '#perform' do
    it 'creates a new case' do
      VCR.use_cassette 'daily_filings_alt_counties' do
        Sidekiq::Testing.inline! do
          Scrapers::DailyFilingsAltCounties.perform('Muskogee', '2010-01-04')
          expect(CourtCase.first).not_to eq(nil)
        end
      end
    end
  end
end
