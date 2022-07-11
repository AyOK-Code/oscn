require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::MediumPriority do
  describe '#perform' do
    it 'adds jobs to the CourtCaseWorker' do
      test_case = create(:court_case, :with_html, closed_on: '6/15/2022')
      test_case.case_html.update(scraped_at: '6/15/2022')
      false_case = create(:court_case, :with_html, closed_on: '6/11/2022')
      false_case.case_html.update(scraped_at: '7/11/2022')

      # data = described_class.perform
      expect do
        described_class.perform
      end.to change(CourtCaseWorker.jobs, :size).by(1)
    end
  end
end
