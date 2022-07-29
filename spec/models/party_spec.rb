require 'rails_helper'

RSpec.describe Party, type: :model do
  describe 'associations' do
    it { should belong_to(:party_type) }
    it { should belong_to(:parent_party).optional }
    it { should have_many(:case_parties).dependent(:destroy) }
    it { should have_many(:court_cases).through(:case_parties) }
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:counsels).through(:counsel_parties) }
    it { should have_many(:docket_events).dependent(:destroy) }
    it { should have_many(:addresses).class_name('PartyAddress').dependent(:destroy) }
    it { should have_one(:party_html).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:oscn_id) }
    subject { FactoryBot.build(:party) }
    it { should validate_uniqueness_of(:oscn_id) }
  end

  describe 'scopes' do
    describe '#older_than' do
      context 'with newer and older parties' do
        let(:date) { Time.current - 1.year }
        let!(:older_party) { create(:party, party_html: create(:party_html, scraped_at: date - 1.day)) }
        let!(:newer_party) { create(:party, party_html: create(:party_html, scraped_at: date + 1.day)) }
        it 'only includes older parties' do
          expect(described_class.older_than(date).map(&:id)).to eq([older_party.id])
        end
      end
    end

    describe '#without_html' do
      context 'with parties with and without html' do
        let!(:with_html) { create(:party, :with_html) }
        let!(:without_html) { create(:party) }
        it 'only includes parties without html' do
          expect(described_class.without_html.map(&:id)).to eq([without_html.id])
        end
      end
    end

    describe '#without_birthday' do
      it 'Filter to parties without birth month' do
        party_bad = create(:party, birth_month: 12)
        create(:party)
        expect(described_class.without_birthday.size).to eq(1)
        expect(described_class.without_birthday.first.id).not_to eq(party_bad.id)
      end
    end

    describe '#without_parent' do
      let!(:parent_party) { create(:parent_party) }
      it 'Filter to parties without parent party' do
        party_bad = create(:party, birth_month: 12, parent_party: parent_party)
        create(:party)
        expect(described_class.without_parent.size).to eq(1)
        expect(described_class.without_parent.first.id).not_to eq(party_bad.id)
      end
    end

    describe '#with_parent' do
      let(:parent_party) { create(:parent_party) }
      it 'Filter to parties with parent party' do
        party_good = create(:party, birth_month: 12, parent_party: parent_party)
        create(:party)
        expect(described_class.with_parent.size).to eq(1)
        expect(described_class.with_parent.first.id).to eq(party_good.id)
      end
    end

    describe '#arresting_agency' do
      it 'filter by party type where party type is arresting_agency' do
        party_good = create(:party, :arresting_agency)
        create(:party)
        expect(described_class.arresting_agency.size).to eq(1)
        expect(described_class.arresting_agency.first.id).to eq(party_good.id)
      end
    end

    describe '#defendant' do
      it 'filter by party type where party type is defendant' do
        party_good = create(:party, :defendant)
        create(:party)
        expect(described_class.defendant.size).to eq(1)
        expect(described_class.defendant.first.id).to eq(party_good.id)
      end
    end
  end
end
