class OkSos::Officer < ApplicationRecord
  belongs_to :entity_address, class_name: 'OkSos::EntityAddress', optional: true
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true
  belongs_to :suffix, class_name: 'OkSos::Suffix', optional: true
end
