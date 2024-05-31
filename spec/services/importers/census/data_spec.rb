require 'rails_helper'

RSpec.describe Importers::Census::Data do
  before do
    Rails.application.load_seed
  end
  describe '#perform' do
    let(:statistic) do
      create(:statistic,
             name: 'B25039_002E',
             survey: create(:survey, name: Census::Survey::ACS5, year: 2018))
    end
    it 'creates data for the statistic' do
      VCR.use_cassette 'census_data' do
        described_class.perform(
          statistic.survey,
          { statistic.name => statistic },
          county_names: [County::OKLAHOMA]
        )
        expect(statistic.datas.first).not_to be nil
      end
    end
  end
end
