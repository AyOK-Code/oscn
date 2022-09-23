require 'rails_helper'
require 'sidekiq/testing'
#require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true)
#Sidekiq::Testing.fake!


RSpec.describe Scrapers::HighPriority do
  before do
    ENV['CASE_TYPES_ABBREVIATION'] = 'CF'
  end
  describe '#perform' do
    #let!(:case_type1) { create(:case_type,name:'CIVIL RELIEF MORE THAN $10,000',abbreviation:'CJ') }
    #let!(:case_type2) { create(:case_type,name:'CIVIL RELIEF LESS THAN $10,000',abbreviation:'CS') }
    it 'add specs' do
      #do creates outside of test
      county = create(:county, name: 'Tulsa')
      test_case = create(:court_case, :felony,closed_on: 7.days.ago, county: county)

      create(:court_case,closed_on: 2.days.ago, county: county)

      data = described_class.perform('Tulsa')
      binding.pry
      expect do
        described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
      end
      expect(data.first).to eq test_case.oscn_id
    end
  end
end
