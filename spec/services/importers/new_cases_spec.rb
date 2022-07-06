require 'rails_helper'

RSpec.describe Importers::NewCourtCase do
  describe '#perform' do
    it 'perform correctly finds or creates and returns a new case' do
      create(:county, name: 'Oklahoma')
      create(:case_type, :felony)
      create(:county, name: 'Arkansas')
      create(:case_type, :misdemeanor)
      file_path = 'spec/fixtures/importers/link.html'
      html = File.open(file_path).read
       link_html = Nokogiri::HTML.parse(html)
       link_html = link_html.css('a').first

      data = described_class.new(link_html)
      data.perform
      expect(data.case_number).to eq "CF-2021-489"
      expect(data.case_types.keys.first).to eq "CF"
      expect(data.counties.keys.first).to eq "Oklahoma"
          
      
    end
  end
end
