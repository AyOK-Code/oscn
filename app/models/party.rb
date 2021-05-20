class Party < ApplicationRecord
  belongs_to :party_type
  has_many :case_parties, dependent: :destroy
  has_many :cases, through: :case_parties
end
