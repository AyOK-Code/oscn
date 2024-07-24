class OkSos::Capacity < ApplicationRecord
  has_many :associated_entities, class_name: 'OkSos::AssociatedEntity'
end
