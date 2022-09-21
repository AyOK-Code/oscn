require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::LowPriority do
  describe '#perform' do
    it 'add specs' do
      test_case = create(:court_case, :with_html, closed_on: 7.months.ago)
      test_case.case_html.update(scraped_at: 7.months.ago)

      data = described_class.perform

      expect do
        described_class.perform
      end.to change(CourtCaseWorker.jobs, :size).by(1)
      expect(data.first.oscn_id).to eq test_case.oscn_id
    end
  end
end
