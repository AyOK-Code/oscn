require 'rails_helper'

RSpec.describe Importers::Census::Import do
  describe '#perform' do
    it 'imports data' do
      ENV['CENSUS_KEY']='b33136401e0ddf4cdaa05bb4d6a4be93271c9681'
       VCR.use_cassette 'census_total_males' do
        importer = described_class.new(
          ['B25039_002E'],
          Importers::Census::Import::SURVEY_ACS5,
          2021,
          county_names: [Importers::Census::Import::COUNTIES_OKLAHOMA]
        )
        expect { importer.perform }.not_to raise_error
        expect(Census::Survey.first).not_to be_nil
        expect(Census::Statistic.first).not_to be_nil
        expect(Census::Data.first).not_to be_nil
      end
    end
  end
end
