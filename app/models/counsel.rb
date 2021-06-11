class Counsel < ApplicationRecord
  has_many :counsel_parties, dependent: :destroy
  has_many :parties, through: :counsel_parties
  # TODO: Add unique constraint on bar_number
end
