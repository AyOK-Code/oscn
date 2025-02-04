require 'rails_helper'

RSpec.describe Importers::Ok2Explore::ScrapePendingJobs do
  describe '#perform' do
    before do
      Rails.application.load_seed
      scraped_records = [{
        'lastName' => 'UNDER',
        'firstName' => 'DAVID',
        'middleName' => 'J',
        'deathDate' => '2019-12-25T00:00:00',
        'deathDay' => 25,
        'deathMonth' => 12,
        'deathYear' => 2019,
        'deathCounty' => 'Comanche',
        'gender' => 'M'
      }]
      allow_any_instance_of(::Ok2explore::Scraper).to receive(:perform).and_return(scraped_records)
    end
    let!(:scrape_job) { create(:ok2_explore_scrape_job, year: 2019, month: 12, first_name: 'd', last_name: 'u') }
    it 'creates death records' do
      described_class.perform(10)
      expect(Ok2Explore::Death.count).to be >= 1
    end
  end
end
