require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::Case do
  
  describe '#perform' do
    let!(:county) {create(:county, name: 'Tulsa')}
      let!(:low_case) {create(:court_case, :with_html,county: county,case_number:'CF-2020-001',closed_on: 89.days.ago)}
      let!(:med_case) {create(:court_case, :with_html,county:county,case_number:'CF-2020-002')}
      let!(:high_case) {create(:court_case, :with_html,county:county,case_number:'CF-2020-003')}
     
    
    context 'Low' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
        county.save
        low_case.case_html.update(scraped_at: 89.days.ago)
        low_case.case_html.save
        low_case.save

        med_case.save
        high_case.save
        binding.pry
      end
    it ' adds a low priority case' do
      binding.pry
      
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
