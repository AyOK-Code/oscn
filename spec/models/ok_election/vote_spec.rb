require 'rails_helper'

RSpec.describe OkElection::Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:voter).class_name('OkElection::Voter') }
    it { should belong_to(:voting_method).class_name('OkElection::VotingMethod') }
  end

  describe 'validations' do
    it { should validate_presence_of(:voter_id) }
    it { should validate_presence_of(:election_date) }
    it { should validate_presence_of(:voting_method_id) }
  end
end
