require 'rails_helper'

RSpec.describe Importers::DocketEvent do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/docket_event_data.json' }
    let(:test_data) { parse_json(file_path) }
    let(:court_case) { create(:court_case) }
    let(:log) { Importers::Logger.new(court_case) }
    it 'creates a new docket_event_type if it does not exist' do
      described_class.perform(test_data, court_case, log)

      expect(DocketEventType.all.size).to eq(2)
    end

    it 'parses the amount correctly' do
      described_class.perform(test_data, court_case, log)
      expect(court_case.docket_events.first.amount).to eq(25.50)
    end

    it 'successfully saves the docket event' do
      described_class.perform(test_data, court_case, log)

      expect(court_case.docket_events.all.size).to eq(2)
    end

    it 'updates existing docket events' do
      create(:docket_event, row_index: 0, court_case: court_case, description: 'Test Text')
      description = "CRIMINAL FELONY INITIAL FILING. Document Available at Court Clerk's Office"
      described_class.perform(test_data, court_case, log)

      expect(court_case.docket_events.all.size).to eq(2)
      expect(court_case.docket_events.first.description).to include(description)
    end
  end
end
