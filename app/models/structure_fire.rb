class StructureFire < ApplicationRecord
  belongs_to :structure_fire_link

  validates :incident_number, presence: true
end
