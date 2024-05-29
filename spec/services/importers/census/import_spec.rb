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
          name: 'B25039_002E',
          label: 'Estimate!!Median year householder moved into unit --!!Total:!!Owner occupied',
          concept: 'MEDIAN YEAR HOUSEHOLDER MOVED INTO UNIT BY TENURE',
          group: 'B25039',
          predicate_type: 'string'
        )

        oklahoma_county_data = statistic.datas.first
        expect(oklahoma_county_data).to have_attributes(
          amount: "2009",
          area_type: 'County'
        )
        expect(oklahoma_county_data.area).to have_attributes(
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
          zips: Importers::Census::Import::ZIPS_OKLAHOMA_COUNTY
        )
        expect { importer.perform }.not_to raise_error
        expect(Census::Data.all.includes(:area).map {|data| data.area.name}).to include '73020'
      end
    end
  end
end
