FactoryBot.define do
  factory :ok2_explore_death, class: 'Ok2Explore::Death' do
    last_name { 'MyString' }
    first_name { 'MyString' }
    middle_name { 'MyString' }
    sex { 1 }
    county { nil }
    death_on { '2023-08-12 09:07:08' }
  end
end
