FactoryBot.define do
  factory :doc_facility do
    name { Faker::Lorem.unique.word }
    is_prison { false }
  end
end
