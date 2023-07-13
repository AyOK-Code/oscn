require 'rails_helper'

RSpec.describe Importers::Attorney do
  describe '#perform' do
    it 'does not override OK Bar data' do
      skip
    end

    it 'logs when a name does not match what currently exists for that bar number' do
      skip
    end

    it 'creates the counsel if one is not found' do
      data = File.read('spec/fixtures/importers/attorney_data.json')
      parsed = JSON.parse(data)
      attorney_object = parsed.map(&:with_indifferent_access)

      party = create(:party, full_name: 'THREADGILL,   GEORGE  HOWARD  III')
      case_party = create(:case_party, party:)
      court_case = case_party.court_case

      expect(court_case.counsels.count).to eq 0

      described_class.perform(attorney_object, court_case, {})

      expect(court_case.counsels.count).to eq 1
      expect(court_case.counsels.first.name).to eq 'jones, jerry'
    end

    it 'creates the counsel party relationship' do
      skip
    end

    it 'logs when a counsel does not have a bar number' do
      skip
    end
  end
end
