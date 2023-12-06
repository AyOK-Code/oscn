FactoryBot.define do
  factory :structure_fire do
    incident_number { Faker::Number.between(from: 1, to: 1000) }
    incident_type { 'MyString' }
    station { Faker::Lorem.word(+' Station') }
    incident_date { '2023-12-01' }
    street_number { 1 }
    street_prefix { 'MyString' }
    street_name { 'MyString' }
    street_type { 'MyString' }
    property_value { Faker::Number.decimal(l_digits: 2) }
    property_loss { Faker::Number.decimal(l_digits: 2)  }
    content_value { Faker::Number.decimal(l_digits: 2)  }
    content_loss { Faker::Number.decimal(l_digits: 2) }
  end
end
