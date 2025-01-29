require 'rails_helper'

RSpec.describe Importers::Ok2Explore::ScrapePendingJobs do
  describe '#perform' do
    before do
      Rails.application.load_seed
    end
    let!(:scrape_job) { create(:ok2_explore_scrape_job, year: 2019, month: 12, first_name: 'd', last_name: 'u') }
    it 'creates death records' do
      VCR.use_cassette 'ok2_explore_pending_jobs' do
        described_class.perform(10)
        expect(Ok2Explore::Death.count).to be >= 1
      end
    end
  end
end
