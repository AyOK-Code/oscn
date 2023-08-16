require 'rails_helper'

RSpec.describe Importers::DocketEvents::Link do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/docket_event_link_data.json' }
    let(:test_data) { parse_json(file_path) }
    let(:docket_event) { create(:docket_event) }

    it 'creates a new docket event links if it does not exist' do
      described_class.perform(test_data.first[:links], docket_event)
      expect(docket_event.links.count).to eq(2)
    end

    it 'ignores duplicates' do
      create(:docket_event_link, docket_event: docket_event, oscn_id: 1_050_827_996, title: 'TIFF',
                                 link: 'GetDocument.aspx?ct=tulsa&cn=CF-2020-49&bc=1050827996&fmt=tif')
      described_class.perform(test_data.first[:links], docket_event)
      expect(docket_event.links.count).to eq(2)
    end
  end
end
