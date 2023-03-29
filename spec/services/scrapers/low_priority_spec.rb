require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::LowPriority do
  describe '#perform' do
    it 'adds jobs to the CourtCaseWorker' do
      test_case = create(:court_case, :with_html, closed_on: 7.months.ago)
      test_case.case_html.update(scraped_at: 7.months.ago)
      data = nil


      expect do
        data = described_class.perform
      end.to change(CourtCaseWorker.jobs, :size).by(1)
      expect do
        described_class.perform
      end.to change(CourtCaseWorker.jobs, :size).by(0)
      expect(data.first.id).to eq test_case.id
    end
  end
end
