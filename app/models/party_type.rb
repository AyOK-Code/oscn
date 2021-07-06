class PartyType < ApplicationRecord
  has_many :parties, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
