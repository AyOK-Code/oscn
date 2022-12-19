class Parcel < ApplicationRecord
  validates :geoid20, :tract, :block, presence: true
end
