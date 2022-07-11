require 'rails_helper'

RSpec.describe Scrapers::HighPriority do
  describe '#perform' do
    it 'add specs' do
        test_case = create(:court_case, :with_html, closed_on: '6/15/2022')
        test_case.case_html.update(scraped_at: '6/15/2022')
        false_case = create(:court_case, :with_html, closed_on: '7/11/2022')
        false_case.case_html.update(scraped_at: '7/11/2022')
        
  
        # data = described_class.perform
        expect do
          described_class.perform.to change(CourtCaseWorker.jobs, :size).by(1)
        end
    end
  end
end
