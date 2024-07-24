class OkSos::StockType < ApplicationRecord
  has_many :stocks, class_name: 'OkSos::StockData'

  validates :stock_type_id, :stock_type_description, presence: true
end
