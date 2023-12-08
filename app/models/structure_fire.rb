class StructureFire < ApplicationRecord
  belongs_to :structure_fire_link

  validates :incident_number, :incident_type, :station, :incident_date, :street_number, :street_prefix, :street_name,
            :street_type, presence: true
end
