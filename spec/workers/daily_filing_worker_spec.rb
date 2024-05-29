require 'rails_helper'

RSpec.describe DailyFilingWorker, type: :worker do
  describe '#perform' do
    let(:county_name) { 'Oklahoma' }
    let(:date) { Date.today }

    it 'calls the DailyFiling scraper with the provided arguments' do
      expect(Scrapers::DailyFiling).to receive(:perform).with(county_name, date)
      subject.perform(county_name, date)
    end

    it 'is a Sidekiq worker' do
      expect(DailyFilingWorker).to include(Sidekiq::Worker)
    end

    it 'is a Sidekiq throttled worker' do
      expect(DailyFilingWorker).to include(Sidekiq::Throttled::Worker)
    end

    it 'has Sidekiq retry options set to 5' do
      expect(DailyFilingWorker.sidekiq_options['retry']).to eq(5)
    end
  end
end
