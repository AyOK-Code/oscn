FactoryBot.define do
  factory :case_not_found do
    county
    case_number { "CF-#{Faker::Number.between(from: 1990, to: 2025)}-#{Faker::Number.between(from: 1, to: 1000)}" }
  end
end
