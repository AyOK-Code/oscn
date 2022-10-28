require 'rails_helper'

RSpec.describe Scrapers::OcsoWarrants do
  describe '#perform' do
    # this test works however it requires a cassett to large to commit
    # remove the x from it to test
    xit 'upserts the result of scraping the ocso site' do
      VCR.use_cassette 'ocso' do
        warrants_count = ::Osco::Warrant.count
        described_class.perform
        expect(::Osco::Warrant.count).to be > warrants_count
      end
    end
  end
end