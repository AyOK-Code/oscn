class OkSos::StockData < ApplicationRecord
  belongs_to :entity, class_name: 'OkSos::Entity', optional: true
  belongs_to :stock_type, class_name: 'OkSos::StockType'
end
