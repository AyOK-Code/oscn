require 'rails_helper'

RSpec.describe Importers::CourtCase do
  describe '#perform' do
    it 'saves data for a case' do
      # Create a case with html from fixture
      county = create(:county, name: 'Tulsa')
      create(:judge, name: 'CF Docket E')
      court_case = create(:court_case, county_id: county.id, case_number: 'CF-2018-1016')
      html = File.open('spec/fixtures/example.html').read
      create(:case_html, court_case: court_case, html: html)

      # Run importer
      described_class.new(county.id, 'CF-2018-1016').perform
      court_case = CourtCase.find(court_case.id) # Pull updated object

      expect(court_case.parties.count).to eq 3
      expect(court_case.counts.count).to eq 5
      expect(court_case.current_judge.name).to eq 'CF Docket E'
      expect(court_case.events.count).to eq 30
      expect(court_case.counsels.count).to eq 1
      expect(court_case.docket_events.count).to eq 247
    end
  end
end
