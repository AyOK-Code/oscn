FactoryBot.define do
  factory :judge do
    name { Faker::Name.full_name }
    judge_type { ['Special', 'Inactive', 'District'].sample }
    county
  end
end
