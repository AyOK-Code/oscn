FactoryBot.define do
  factory :ok2_explore_death, class: 'Ok2Explore::Death' do
    last_name { Faker::Name.first_name }
    first_name { Faker::Name.last_name }
    middle_name { Faker::Name.middle_initial }
    sex { ['male', 'female'].sample }
    county
    death_on { '2023-08-12 09:07:08' }
  end
end
