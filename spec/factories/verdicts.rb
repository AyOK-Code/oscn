FactoryBot.define do
  factory :verdict do
    name { Faker::Lorem.unique.word }
  end
end
