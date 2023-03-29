require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::MediumPriority do
  describe '#perform' do
    it 'adds jobs to the CourtCaseWorker' do
      test_case = create(:court_case, :with_html, closed_on: 14.days.ago)
      test_case.case_html.update(scraped_at: 14.days.ago)
      false_case = create(:court_case, :with_html, closed_on: 3.days.ago)
      false_case.case_html.update(scraped_at: 3.days.ago)

      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
      end
    end

    it 'no duplicates in worker' do
      test_case = create(:court_case, :with_html, closed_on: 14.days.ago)
      test_case.case_html.update(scraped_at: 14.days.ago)
      false_case = create(:court_case, :with_html, closed_on: 3.days.ago)
      false_case.case_html.update(scraped_at: 3.days.ago)
      described_class.perform

      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(0)
      end
    end
  end
end
