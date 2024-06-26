FactoryBot.define do
  factory :ok_sos_stock_type, class: 'OkSos::StockType' do
    stock_type_id { Faker::Number.number(digits: 10) }
  end
end
