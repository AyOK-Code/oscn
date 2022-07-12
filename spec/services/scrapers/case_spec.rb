require 'rails_helper'

RSpec.describe Scrapers::Case do
  
  describe '#perform' do
    
    context 'Low' do
      before do
        ENV['COUNTIES'] = 'Tulsa'
      end
    it 'add specs' do
      county = create(:county, name: 'Tulsa')
      test_case = create(:court_case, :with_html, closed_on: '1/1/2022')
      test_case.case_html.update(scraped_at: '1/1/2022')
      binding.pry
      described_class.perform
    end
  end
    context 'Med' do
      before do
      end
      it 'add specs' do
        described_class.perform
      end
    end
    context 'High' do
      before do
      end
      it 'add specs' do
        described_class.perform
      end
    end
  end
  end
