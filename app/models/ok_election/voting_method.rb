class OkElection::VotingMethod < ApplicationRecord
  has_many :votes, class_name: 'OkElection::Vote', dependent: :destroy

  validates :name, :code, presence: true
end
