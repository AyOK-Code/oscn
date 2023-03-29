require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::HighPriority do
  describe '#perform' do
    # let(:test_case) {create(:court_case, closed_on: 7.days.ago, county: county)}
    before(:all) do
      @county =  create(:county, name: 'Tulsa')
      @test_case = create(:court_case, closed_on: 7.days.ago, county: @county)
      @data = nil
    end

    it 'adds jobs to the CourtCaseWorker' do
      create(:court_case, closed_on: 2.days.ago, county: @county)

      @data = described_class.perform('Tulsa')

      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
      end

      expect(@data.first).to eq @test_case.case_number
    end

    it 'doesnt add duplicate job to queue' do
      create(:court_case, closed_on: 7.days.ago, county: @county)

      create(:court_case, closed_on: 2.days.ago, county: @county)
      described_class.perform('Tulsa')

      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(0)
      end
    end
  end
end
