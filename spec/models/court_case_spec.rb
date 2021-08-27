require 'rails_helper'

RSpec.describe CourtCase, type: :model do
  context 'associations' do
    it { should belong_to(:county) }
    it { should belong_to(:case_type) }
    it { should belong_to(:current_judge).class_name('Judge').with_foreign_key('current_judge_id').optional }
    it { should have_many(:case_parties).dependent(:destroy) }
    it { should have_many(:parties).through(:case_parties) }
    it { should have_many(:counts).dependent(:destroy) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:counsels).through(:counsel_parties) }
    it { should have_many(:docket_events) }
  end

  context 'validations' do
    it { should validate_presence_of(:oscn_id) }
    it { should validate_presence_of(:case_number) }
    subject { FactoryBot.build(:court_case) }
    it { should validate_uniqueness_of(:oscn_id) }
  end

  # Scopes
  describe '#without_html' do
    it 'records that have not been scraped' do
      court_case = create(:court_case)
      create(:court_case, :with_html)

      scoped_data = described_class.without_html

      expect(scoped_data.count).to eq 1
      expect(scoped_data).to include court_case
    end
  end

  describe '#with_html' do
    it 'records that have been scraped' do
      court_case = create(:court_case)
      create(:court_case, :with_html)

      scoped_data = described_class.with_html

      expect(scoped_data.count).to eq 1
      expect(scoped_data).to_not include court_case
    end
  end

  describe '#without_docket_events' do
    it 'scopes to court_cases without docket events' do
      court_case = create(:court_case)
      create(:court_case, :with_docket_event)

      scoped_data = described_class.without_docket_events

      expect(scoped_data.count).to eq 1
      expect(scoped_data).to include court_case
    end
  end

  describe '#valid' do
    it 'filters out the cases that end in "-0"' do
      valid = create(:court_case, case_number: 'CF-2020-1')
      invalid = create(:court_case, :invalid)

      scoped_data = described_class.valid

      expect(scoped_data).to include valid
      expect(scoped_data).to_not include invalid
    end
  end

  describe '#active' do
    it 'returns cases without a closed on date' do
      active = create(:court_case, :active)
      create(:court_case, :inactive)

      scoped_data = described_class.active

      expect(scoped_data.count).to eq 1
      expect(scoped_data).to include active
    end
  end

  describe '#closed' do
    it 'returns cases with a closed_on date' do
      create(:court_case, :active)
      inactive = create(:court_case, :inactive)

      scoped_data = described_class.closed

      expect(scoped_data.count).to eq 1
      expect(scoped_data).to include inactive
    end
  end

  describe '#last_scraped(date)' do
    it 'returns cases that have scraped between the date given and the present date' do
      travel_to(Date.new(2021, 1, 1)) do
        in_range = create(:case_html, scraped_at: Date.new(2020, 6, 1))
        too_old = create(:case_html, scraped_at: Date.new(2019, 6, 1))

        scoped_data = described_class.last_scraped(Date.new(2020, 1, 1))

        expect(scoped_data.count).to eq 1
        expect(scoped_data).to include in_range.court_case
        expect(scoped_data).to_not include too_old.court_case
      end
    end
  end

  describe '#older_than(date)' do
    it 'returns cases that have not been scraped since the date given' do
      travel_to(Date.new(2021, 1, 1)) do
        recent = create(:case_html, scraped_at: Date.new(2020, 12, 29))
        needs_scrape = create(:case_html, scraped_at: Date.new(2020, 11, 11))

        scoped_data = described_class.older_than(1.month.ago)

        expect(scoped_data.count).to eq 1
        expect(scoped_data).to_not include recent.court_case
        expect(scoped_data).to include needs_scrape.court_case
      end
    end
  end

  describe '#with_error' do
    it '' do
      skip
    end
  end
end
