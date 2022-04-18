require 'rails_helper'

RSpec.describe CaseStat, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
  end

  describe 'view data' do
    let!(:court_case) { create(:court_case, filed_on: 7.days.ago, closed_on: 1.day.ago) }

    it 'calculates the length of the case in days' do
      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.first.length_of_case_in_days).to eq 6
    end

    it 'counts the number of counts attached to the case' do
      create(:count, court_case: court_case)
      create(:count, court_case: court_case)
      # Create count attached to a difference case
      create(:count)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(described_class.find_by(court_case_id: court_case.id).counts_count).to eq 2
    end

    it 'counts the number of defendants on the case' do
      defendant = create(:party, :defendant)
      plantiff = create(:party, :plantiff)
      create(:case_party, party: defendant, court_case: court_case)
      create(:case_party, party: plantiff, court_case: court_case)

      # Defendant that should not be counted
      other_defendant = create(:party, :defendant)
      create(:case_party, party: other_defendant)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(described_class.find_by(court_case_id: court_case.id).defendant_count).to eq 1
    end

    it 'flags cases that tax intercepted' do
      with_ctrs = court_case
      without_ctrs = create(:court_case)
      create(:tax_intercept_event, court_case: with_ctrs)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(described_class.find_by(court_case_id: with_ctrs.id).is_tax_intercepted).to be true
    end

    it 'counts the number of warrants on a case' do
      create(:warrant_event, court_case: court_case)
      create(:warrant_event)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(described_class.find_by(court_case_id: court_case.id).warrants_count).to eq 1
    end
  end
end
