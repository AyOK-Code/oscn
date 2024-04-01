FactoryBot.define do
  factory :eviction_letter do
    status { 0 }
    docket_event_link

    trait :with_address do
      validation_usps_address { Faker::Address.street_address }
    end

    trait :with_zip_code do
      validation_zip_code { Faker::Address.zip_code }
    end
  end
end
