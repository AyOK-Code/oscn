require 'rails_helper'

RSpec.describe EvictionLetter, type: :model do
  describe 'associations' do
    it { should belong_to(:docket_event_link) }
  end

  describe '#full_name' do
    it 'returns the defendants full_name' do
      court_case = create(:court_case)
      docket_event = create(:docket_event, court_case: court_case)
      defendant = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant)
      docket_event_link = create(:docket_event_link, docket_event: docket_event)
      eviction_letter = create(:eviction_letter, docket_event_link: docket_event_link)

      expect(eviction_letter.full_name).to eq(defendant.full_name)
    end

    it 'returns multiple defendants full_name seperated by a comma' do
      court_case = create(:court_case)
      docket_event = create(:docket_event, court_case: court_case)
      defendant1 = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant1)
      defendant2 = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant2)
      docket_event_link = create(:docket_event_link, docket_event: docket_event)
      eviction_letter = create(:eviction_letter, docket_event_link: docket_event_link)

      expect(eviction_letter.full_name).to eq("#{defendant1.full_name}, #{defendant2.full_name}")
    end
  end

  describe '#missing_address_validation' do
    it 'returns letters that have not been validated' do
      eviction_letter = create(:eviction_letter, is_validated: false)
      create(:eviction_letter, is_validated: true)

      expect(EvictionLetter.missing_address_validation).to eq([eviction_letter])
    end
  end

  describe '#has_address_validation' do
    it 'returns letters that have been validated' do
      create(:eviction_letter, is_validated: false)
      eviction_letter = create(:eviction_letter, is_validated: true)

      expect(EvictionLetter.has_address_validation).to eq([eviction_letter])
    end
  end

  describe '#missing_extraction' do
    it 'returns letters that have not been extracted' do
      eviction_letter = create(:eviction_letter, ocr_plaintiff_address: nil)
      create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

      expect(EvictionLetter.missing_extraction).to eq([eviction_letter])
    end
  end

  describe '#has_extraction' do
    it 'returns letters that have been extracted' do
      create(:eviction_letter, ocr_plaintiff_address: nil)
      eviction_letter = create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

      expect(EvictionLetter.has_extraction).to eq([eviction_letter])
    end
  end

  describe '#past_thirty_days' do
    it 'returns letters that have been created in the past 30 days' do
      docket_event = create(:docket_event, event_on: 20.days.ago)
      docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
      eviction_letter = create(:eviction_letter, docket_event_link_id: docket_event_link.id)

      expect(EvictionLetter.past_thirty_days).to eq([eviction_letter])
    end

    it 'does not return letters that have been created more than 30 days ago' do
      docket_event = create(:docket_event, event_on: 40.days.ago)
      docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
      create(:eviction_letter, docket_event_link_id: docket_event_link.id)

      expect(EvictionLetter.past_thirty_days).to eq([])
    end
  end
end
