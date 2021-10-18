require 'rails_helper'

RSpec.describe PartyStat, type: :model do
  describe 'view data' do
    it 'counts the number of court cases for a party' do
      party = create(:party, :defendant, :with_case)
      create(:case_party, party: party)
      create(:party, :defendant, :with_case)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(CaseParty.count).to eq 3
      expect(described_class.find_by(party_id: party.id).cases_count).to eq 2
    end

    it 'counts the number of cf cases for a party' do
      party = create(:party, :defendant, :with_felony_case)
      create(:case_party, party: party)
      create(:party, :defendant, :with_case)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(CaseParty.count).to eq 3
      expect(described_class.find_by(party_id: party.id).cf_count).to eq 1
    end

    it 'counts the number of cm cases for a party' do
      party = create(:party, :defendant, :with_misdemeanor_case)
      create(:case_party, party: party)
      create(:party, :defendant, :with_case)

      described_class.refresh

      expect(described_class.count).to eq 2
      expect(CaseParty.count).to eq 3
      expect(described_class.find_by(party_id: party.id).cm_count).to eq 1
    end

    it 'counts the number of warrants issued for a party' do
      party = create(:party, :defendant, :with_felony_case)
      create(:warrant_event, party: party, court_case: party.court_cases.first)

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.first.warrants_count).to eq 1
    end

    it 'calculates the total amount fined' do
      party = create(:party, :defendant)
      create(:docket_event, amount: 300, party: party)
      create(:docket_event, amount: 100, party: party)
      create(:docket_event, amount: 100)

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.find_by(party_id: party.id).total_fined).to eq 400
    end

    it 'calculates the total amount paid' do
      party = create(:party, :defendant)
      create(:docket_event, payment: 300, party: party)
      create(:docket_event, payment: 100, party: party)
      create(:docket_event, payment: 100)

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.find_by(party_id: party.id).total_paid).to eq 400
    end

    it 'calculates the total amount adjusted' do
      party = create(:party, :defendant)
      create(:docket_event, adjustment: 300, party: party)
      create(:docket_event, adjustment: 100, party: party)
      create(:docket_event, adjustment: 100)

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.find_by(party_id: party.id).total_adjusted).to eq 400
    end

    it 'calculates the account_balance' do
      party = create(:party, :defendant)
      create(:docket_event, amount: 500, party: party)
      create(:docket_event, adjustment: 100, party: party)
      create(:docket_event, payment: 300, party: party)
      create(:docket_event, payment: 100)

      described_class.refresh

      expect(described_class.count).to eq 1
      expect(described_class.find_by(party_id: party.id).account_balance).to eq 100
    end
  end
end
