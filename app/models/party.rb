class Party < ApplicationRecord
  belongs_to :party_type
  has_many :case_parties, dependent: :destroy
  has_many :cases, through: :case_parties
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, through: :counsel_parties
  has_many :docket_events, dependent: :destroy
end
