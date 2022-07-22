require 'rails_helper'
require 'byebug'

RSpec.describe Scrapers::DistrictAttorney do
  describe '#perform' do
    fixture_path = 'spec/fixtures/district_attorney.html'
    html = File.read(fixture_path)

    it 'saves  district attorney and hooks up counties' do
      create(:county, name: 'Beaver')
      create(:county, name: 'Cimarron')
      create(:county, name: 'Harper')
      create(:county, name: 'Texas')

      create(:county, name: 'Beckham')
      create(:county, name: 'Custer')
      create(:county, name: 'Ellis')
      create(:county, name: 'Roger Mills')
      create(:county, name: 'Washita')

      create(:county, name: 'Greer')
      create(:county, name: 'Harmon')
      create(:county, name: 'Jackson')
      create(:county, name: 'Kiowa')
      create(:county, name: 'Tillman')

      parser = OscnScraper::Parsers::DistrictAttorney.new(html)
      parser.perform

      data = parser.district_attorneys
      test = described_class.new(data)
      test.perform

      test_attorney = DistrictAttorney.find_by! name: 'George Leach'
      county = County.find_by! name: 'Beaver'

      expect(county.district_attorney_id).to eq test_attorney.id
      expect(DistrictAttorney.all.size).to eq data.size
      expect(test_attorney.name).to eq data.first[:district_attorney]
    end
  end
end
