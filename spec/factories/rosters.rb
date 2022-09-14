FactoryBot.define do
  factory :roster do
    birth_year { 'MyString' }
    birth_month { 'MyString' }
    birth_day { 'MyString' }
    sex { 'MyString' }
    race { 'MyString' }
    street_address { 'MyString' }
    zip { 1 }
    first_name { Faker::Name.name  }
    last_name { Faker::Name.name  }
    middle_name { Faker::Name.name  }
  end
end
