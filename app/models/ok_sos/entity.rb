class OkSos::Entity < ApplicationRecord
  belongs_to :corp_type, class_name: 'OkSos::CorpType'
  belongs_to :entity_address, class_name: 'OkSos::EntityAddress', optional: true
end
