require 'rails_helper'

RSpec.describe Importers::Event do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/event_data.json' }
    let(:test_data) { parse_json(file_path) }
    let(:court_case) { create(:court_case) }
    let(:log) { ::Importers::Logger.new(court_case) }
    context 'event does not exist' do
      it 'creates a event' do
        described_class.perform(test_data, court_case, log)

        expect(Event.all.size).to eq(2)
      end
      it 'links  event to court case' do
        described_class.perform(test_data, court_case, log)

        expect(court_case.events.first.event_at).to eq(test_data.first[:date])
      end
    end

    context 'event does  exist' do
      it 'doesnt make duplicates' do
        described_class.perform(test_data, court_case, log)

        expect(Event.all.size).to eq(2)
      end
      it 'links  event to court case' do
        described_class.perform(test_data, court_case, log)

        expect(court_case.events.first.event_at).to eq(test_data.first[:date])
      end
    end
  end
end
