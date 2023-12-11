class OkElection::Vote < ApplicationRecord
  belongs_to :voter, class_name: 'OkElection::Voter'
  belongs_to :voting_method, class_name: 'OkElection::VotingMethod'

  validates :voter_id, :election_date, :voting_method_id, presence: true
end
