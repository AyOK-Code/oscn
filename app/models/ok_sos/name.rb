class OkSos::Name < ApplicationRecord
  belongs_to :name_type, class_name: 'OkSos::NameType', optional: true
  belongs_to :name_status, class_name: 'OkSos::NameStatus', optional: true
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true
end
