class OkSos::StockInfo < ApplicationRecord
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true
end
