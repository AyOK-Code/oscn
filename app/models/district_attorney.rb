class DistrictAttorney < ApplicationRecord
  validates :name, :number, presence: true
end
