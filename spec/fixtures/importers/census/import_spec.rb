require 'rails_helper'

RSpec.describe Importers::Census::Import do
  describe '#perform' do
    it 'imports data' do
      ENV['CENSUS_KEY']='b33136401e0ddf4cdaa05bb4d6a4be93271c9681'
       VCR.use_cassette 'census_total_males' do
        importer = described_class.new(
          ['B01001_002E'],
          Importers::Census::Import::SURVEY_ACS5,
          2021,
          counties: [Importers::Census::Import::COUNTIES_OKC]
        )
        expect { importer.perform }.not_to raise_error
      end
    end
  end
end
