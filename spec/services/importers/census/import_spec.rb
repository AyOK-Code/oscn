require 'rails_helper'

RSpec.describe Importers::Census::Import do
  before do
    ENV['CENSUS_KEY'] = 'b33136401e0ddf4cdaa05bb4d6a4be93271c9681'
  end
  describe '#perform' do
    it 'imports data for county' do
      Rails.application.load_seed
      VCR.use_cassette 'census_for_county' do
        importer = described_class.new(
          Census::Survey::ACS5,
          2021,
          variables: ['B25039_002E'],
          county_names: [County::OKLAHOMA]
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
          amount: '2009',
          area_type: 'County'
        )
        expect(oklahoma_county_data.area).to have_attributes(
          name: 'Oklahoma'
        )
      end
    end
    it 'imports data for group' do
      ENV['CENSUS_KEY'] = 'b33136401e0ddf4cdaa05bb4d6a4be93271c9681'
      Rails.application.load_seed
      VCR.use_cassette 'census_for_group' do
        importer = described_class.new(
          Census::Survey::ACS5,
          2021,
          group: 'DP03',
          zips: ZipCode::ZIPS_OKLAHOMA_COUNTY,
          table_type: 'profile'
        )
        expect { importer.perform }.not_to raise_error

        statistic = Census::Statistic.first
        expect(statistic.name).to start_with('DP03')
      end
    end
    it 'imports data for zips' do
      VCR.use_cassette 'census_for_zips' do
        importer = described_class.new(
          Census::Survey::ACS5,
          2021,
          variables: ['B25039_002E'],
          zips: ZipCode::ZIPS_OKLAHOMA_COUNTY
        )
        expect { importer.perform }.not_to raise_error
        expect(Census::Data.all.includes(:area).map { |data| data.area.name }).to include '73020'
      end
    end
  end
end
