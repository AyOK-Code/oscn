require 'rails_helper'

RSpec.describe Scrapers::OcsoWarrants do
  describe '#perform' do
    it 'upserts the result of scraping the ocso site' do
      VCR.use_cassette 'ocso' do
        warrants_count = ::Osco::Warrant.count
        described_class.perform
        expect(::Osco::Warrant.count).to be > warrants_count
      end
    end
  end
end
