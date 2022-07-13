require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Case do
  
  describe '#perform' do
    let!(:county) {create(:county, name: 'Tulsa')}
      let!(:test_case) {create(:court_case, :with_html,county: county)}
      let!(:test_case2) {create(:court_case, :with_html,county:county)}
      let!(:test_case3) {create(:court_case, :with_html,county:county)}
      
    
    context 'Low' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
      end
    it 'add specs' do
      test_case.case_html.update(scraped_at: '1/1/2022')
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
      it 'add specs' do
       
      
      test_case2.case_html.update(scraped_at: '24/6/2022')
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
      it 'add specs' do
       
     
      test_case3.case_html.update(scraped_at: '4/7/2022')
      
        described_class.perform
      end
      after do
        ENV['COUNTIES'] = nil
      end
    end
  end
  end
