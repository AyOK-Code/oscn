require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Scrapers::WarrantsView do
  describe '#perform' do
    before(:each) do
      create('Ocso::Warrant')
      county = create(:county, name: 'Oklahoma')
      cc = create(:court_case, case_number: 'CF-94-8641', county_id: county.id)
      pt = create(:party_type, name: 'defendant')
      p = create(:party, party_type_id: pt.id)
      create(:case_party, court_case_id: cc.id, party_id: p.id)
      det = create(:docket_event_type, code: 'BWIFP')
      create(:docket_event, docket_event_type_id: det.id, party_id: p.id)
    end

    it 'adds jobs to the CourtCaseWorker' do
      expect do
        described_class.perform.to change(OneOffCaseWorker.jobs, :size).by(1)
      end
    end
  end
end
