FactoryBot.define do
  factory :case do
    oscn_id { 1 }
    county
    case_type
    case_number { "CF-2020-#{Faker::Number.between(from: 1, to: 1000)}" }
    filed_on { Faker::Date.between(from: 2.years.ago, to: Date.today) }
    html { '<div></div>' }
  end
end
