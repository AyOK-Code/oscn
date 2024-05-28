require 'rails_helper'

RSpec.describe Importers::Census::Import do
  describe '#perform' do
    it 'imports data for county' do
      Rails.application.load_seed
      VCR.use_cassette 'census_for_county' do
        importer = described_class.new(
          ['B25039_002E'],
          Importers::Census::Import::SURVEY_ACS5,
          2021,
          county_names: [Importers::Census::Import::COUNTIES_OKLAHOMA]
        )
        expect { importer.perform }.not_to raise_error

        statistic = Census::Statistic.first

        expect(statistic.survey).to have_attributes(
          name: 'acs5',
          year: 2021
        )
        expect(statistic).to have_attributes(
          name: 'B25039_002E'
        )
        expect(statistic.datas.first.area).to have_attributes(
          name: 'Oklahoma'
        )
      end
    end
    it 'imports data for zips' do
      VCR.use_cassette 'census_for_zips' do
        importer = described_class.new(
          ['B25039_002E'],
          Importers::Census::Import::SURVEY_ACS5,
          2021,
          zips: ['74011']
        )
        expect { importer.perform }.not_to raise_error
        expect(Census::Data.first.area.name).to eq '74011'
      end
    end
  end
end
