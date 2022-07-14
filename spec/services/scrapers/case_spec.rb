require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Case do
  
  describe '#perform' do
    let!(:county) {create(:county, name: 'Tulsa')}
      let!(:low_case) {create(:court_case, :with_html,county: county)}
      let!(:med_case) {create(:court_case, :with_html,county:county)}
      let!(:high_case) {create(:court_case, :with_html,county:county)}
      
    
    context 'Low' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
      end
    it ' adds a low priority case' do
      low_case.case_html.update(scraped_at: 90.days.ago)
      described_class.perform
    end
    after do
      ENV['COUNTIES'] = nil
    end
  end
    context 'Med' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
      end
      it 'adds a med priority case' do
       
      
      med_case.case_html.update(scraped_at: 14.days.ago)
        described_class.perform
      end
      after do
        ENV['COUNTIES'] = nil
      end
    end
    context 'High' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
      end
      it 'adds a high priority case' do
       
     
      high_case.case_html.update(scraped_at: 7.days.ago)
      
        described_class.perform
      end
      after do
        ENV['COUNTIES'] = nil
      end
    end
  end
  end
