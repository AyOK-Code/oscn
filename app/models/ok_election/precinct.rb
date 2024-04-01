class OkElection::Precinct < ApplicationRecord
  belongs_to :county
  has_many :voters, class_name: 'OkElection::Voter', dependent: :destroy
  has_many :votes, through: :voters

  validates :code, :congressional_district, :state_senate_district, :state_house_district, :county_commissioner,
            presence: true
end
