require 'rails_helper'

RSpec.describe Importers::Census::StatisticsByNames do
  before do
    Rails.application.load_seed
  end
  describe '#perform' do
    let(:survey) { create(:survey, name: Census::Survey::ACS5, year: 2020) }
    let(:created_statistic) do
      statistics = nil
      VCR.use_cassette 'statistics_by_names' do
        statistics = described_class.perform(
          survey,
          ['B24022_060E'],
          table_type: 'profile'
        )
      end
      statistics.values.first
    end

    it 'it creates the correct statistics' do
      expect(created_statistic.name).to eq 'B24022_060E'
    end
  end
end
