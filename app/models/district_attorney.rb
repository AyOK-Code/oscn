class DistrictAttorney < ApplicationRecord
  validates :name, :number, presence: true
  has_many :counties
end
