require 'rails_helper'

RSpec.describe Importers::Census::StatisticsByGroup do
  describe '#perform' do
    let(:survey) { create(:survey, name: Census::Survey::ACS5, year: 2020) }
    let(:created_statistics) do
      statistics = nil
      VCR.use_cassette 'statistics_by_group' do
        statistics = described_class.perform(
          survey,
          'DP03',
          table_type: 'profile'
        )
      end
      statistics
    end

    it 'it creates the correct statistics' do
      expect(created_statistics.values.first).not_to be nil
    end

    it 'only selects statistics with the PE or E suffix' do
      expect(
        created_statistics.values.all? do |statistic|
          name_without_numbers = statistic.name.gsub!(/\d+/, '')
          suffix = name_without_numbers.split('_').last
          suffix.in?(['PE', 'E'])
        end
      ).to be true
    end
  end
end
