class OkSos::Entity < ApplicationRecord
  belongs_to :corp_type, class_name: 'OkSos::CorpType'
  belongs_to :address, class_name: 'OkSos::Address', optional: true
end
