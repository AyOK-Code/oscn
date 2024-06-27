FactoryBot.define do
  factory :ok_sos_stock_data, class: 'OkSos::StockData' do
    stock_id { Faker::Number.number(digits: 10) }
    external_stock_type_id { Faker::Number.number(digits: 10) }
    stock_type
  end
end
