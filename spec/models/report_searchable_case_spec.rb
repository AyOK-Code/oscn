require 'rails_helper'

RSpec.describe ReportSearchableCase, type: :model do
  describe 'view data' do
    it 'has a row for each count on a case' do
      count = create(:count)
      create(:count, court_case: count.court_case)

      described_class.refresh

      expect(described_class.count).to eq 2
    end

    it 'flags active warrants true if return warrants > warrants' do
      party = create(:party, :defendant, :with_misdemeanor_case)
      count = create(:count, party: party)
      create(:warrant_event, court_case: count.court_case, party: party)

      ReportWarrants.refresh
      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.first.has_active_warrant).to eq 'Yes'
    end

    it 'calculates inactive warrants' do
      party = create(:party, :defendant, :with_misdemeanor_case)
      count = create(:count, party: party)
      create(:warrant_event, court_case: count.court_case, party: party)
      create(:docket_event, :return_warrant, party: party)

      ReportWarrants.refresh
      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.first.has_active_warrant).to eq 'No'
    end

    it 'extracts the title code from the filed_statute_violation' do
      count = create(:count, filed_statute_violation: '21 O.S. 101')

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.first.title_code).to eq '21'
    end
  end
end
