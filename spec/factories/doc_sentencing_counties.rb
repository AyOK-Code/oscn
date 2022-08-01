FactoryBot.define do
  factory :doc_sentencing_county do
    name { Faker::Lorem.unique.word }
    county { nil }
  end
end
