require 'rails_helper'

RSpec.describe Importers::Count do
  describe '#perform' do
    let(:file_path) { 'spec/fixtures/importers/count_data.json' }
    let(:test_data) { parse_json(file_path) }
    let(:court_case) { create(:court_case) }
    let(:party) { create(:party, full_name: 'PIT, ANTHONY LEE') }

    let(:log) { ::Importers::Logger.new(court_case) }
    it 'logs counts with missing parties' do
      described_class.perform(test_data, court_case, log)
      expect(log.nil?).to eq(false)
    end

    it 'creates the count' do
      court_case.parties.push(party)
      described_class.perform(test_data, court_case, log)
      expect(Count.all.size).to eq(2)
    end

    it 'creates the plea if one is not found' do
      described_class.perform(test_data, court_case, log)
      expect(Plea.all.size).to eq(1)
      expect(Plea.all.first.name.upcase).to include(test_data.first[:plea].upcase)
    end

    it 'creates the verdict if one is not found' do
      described_class.perform(test_data, court_case, log)
      expect(Verdict.all.size).to eq(1)
      expect(Verdict.all.first.name.upcase).to include(test_data.first[:verdict].upcase)
    end
  end
end
