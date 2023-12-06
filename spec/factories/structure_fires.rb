FactoryBot.define do
  factory :structure_fire do
    incident_number { Faker::Number.between(from: 1, to: 1000) }
    incident_type { 'MyString' }
    station { 'MyString' }
    incident_date { '2023-12-01' }
    street_number { 1 }
    street_prefix { 'MyString' }
    street_name { 'MyString' }
    street_type { 'MyString' }
    property_value { '9.99' }
    property_loss { '9.99' }
    content_value { '9.99' }
    content_loss { '9.99' }
  end
end
