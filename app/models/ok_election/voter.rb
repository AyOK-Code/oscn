class OkElection::Voter < ApplicationRecord
  belongs_to :precinct, class_name: 'OkElection::Precinct'
  belongs_to :zip_code
  has_many :votes, class_name: 'OkElection::Vote', dependent: :destroy

  validates :precinct_id, :voter_id, :political_affiliation, :status, presence: true

  enum political_affiliation: {
    REP: 1,
    DEM: 2,
    IND: 3,
    LIB: 4
  }

  enum status: {
    inactive: 0,
    active: 1
  }
end
