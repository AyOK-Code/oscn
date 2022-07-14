FactoryBot.define do
  factory :party_alias do
    party
    name { Faker::Name.name }
  end
end
