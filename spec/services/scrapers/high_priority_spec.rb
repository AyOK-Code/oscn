require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::HighPriority do
  describe '#perform' do
    it 'add specs' do
      county = create(:county, name: 'Tulsa')
      test_case = create(:court_case, closed_on: '6/15/2022', county: county)

      create(:court_case, closed_on: '7/11/2022', county: county)

      data = described_class.perform('Tulsa')
      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
      end
      expect(data.first).to eq test_case.case_number
    end
  end
end
