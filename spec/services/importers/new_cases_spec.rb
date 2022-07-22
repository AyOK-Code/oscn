require 'rails_helper'

RSpec.describe Importers::NewCourtCase do
  describe '#perform' do
    it 'saves to the database' do
      county = create(:county, name: 'Oklahoma')
      create(:case_type, :felony)

      file_path = 'spec/fixtures/importers/link.html'
      html = File.read(file_path)
      link_html = Nokogiri::HTML.parse(html)
      link_html = link_html.css('a').first

      data = described_class.new(link_html)
      data.perform
      oscn_id = data.params['casemasterID']
      court_case = CourtCase.find_by(county_id: county.id, oscn_id: oscn_id)

      
      expect(court_case.case_number).to eq 'CF-2021-489'
      expect(court_case.case_number[0..1]).to eq 'CF'
      expect(court_case.county.name).to eq 'Oklahoma'
    end

    it ' does not duplicate' do
    county=  create(:county, name: 'Oklahoma')
     create(:court_case, :felony , county_id: county.id, oscn_id: 3946802)
      file_path = 'spec/fixtures/importers/link.html'
      html = File.read(file_path)
      link_html = Nokogiri::HTML.parse(html)
      link_html = link_html.css('a').first

      data = described_class.new(link_html)
      data.perform

      
      expect(CourtCase.all.size).to eq 1
    end
  end
end
