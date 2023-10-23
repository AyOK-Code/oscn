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
end
