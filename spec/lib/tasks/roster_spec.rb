require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'roster' do
  
let!(:test_profile) {create(:doc_profile,roster:nil)}
let!(:test_roster) {create(:roster)}
let!(:false_profile) {create(:doc_profile, roster:test_roster)}
    context 'There are profiles with roster ids and some without' do
      
      it 'creates roster and attaches it to profile without roster' do
        Rake::Task['roster:empty_doc_profiles'].invoke
        test_id = test_profile.id
        test_profile = Doc::Profile.find_by(id:test_id)
        expect(test_profile.roster).not_to  be nil
        expect(false_profile.roster_id).to  be test_roster.id
        expect(Doc::Profile.where(roster_id: nil).count).to be 0

      end
    end
  end

