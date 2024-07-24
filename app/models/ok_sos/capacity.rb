class OkSos::Capacity < ApplicationRecord
  has_many :associated_entities, class_name: 'OkSos::AssociatedEntity'

  validates :capacity_id, :description, presence: true
end
