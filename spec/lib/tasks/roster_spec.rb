require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'roster' do
  let!(:test_profile) { create(:doc_profile, roster: nil ,first_name:'Bilbo',middle_name:'G',last_name: 'Baggins',birth_date:'2022-01-24',sex:'male',race:'white') }
  let!(:test_roster) { create(:roster) }
  let!(:false_profile) { create(:doc_profile, roster: test_roster) }
  context 'There are profiles with roster ids and some without' do
    it 'creates roster and attaches it to profile without roster' do
      Rake::Task['roster:empty_doc_profiles'].invoke
      test_id = test_profile.id
      test_profile = Doc::Profile.find_by(id: test_id)
      expect(test_profile.roster).not_to  be nil
      expect(false_profile.roster_id).to  be test_roster.id
      expect(Doc::Profile.where(roster_id: nil).count).to be 0
    end
    it 'shares the correct fields with doc_profiles' do
      Rake::Task['roster:empty_doc_profiles'].invoke
      test_roster = test_profile.roster
      expect(test_roster.first_name).to  be test_profile.first_name
      expect(test_roster.last_name).to  be test_profile.last_name
      expect(test_roster.middle_name).to  be test_profile.middle_name
      expect(test_roster.birth_month).to  be test_profile.birth_date.month
      expect(test_roster.birth_day).to  be test_profile.birth_date.day
      expect(test_roster.birth_year).to  be test_profile.birth_date.year
      expect(test_roster.sex).to  be test_profile.sex
      expect(test_roster.race).to  be test_profile.race
   
    end
  end
end
