require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::LowPriority do
  describe '#perform' do
    it 'add specs' do
      test_case = create(:court_case, :with_html, closed_on: '1/1/2022')
      test_case.case_html.update(scraped_at: '1/1/2022')

      data = described_class.perform

      expect do
        described_class.perform
      end.to change(CourtCaseWorker.jobs, :size).by(1)
      expect(data.first.id).to eq test_case.id
    end
  end
end
