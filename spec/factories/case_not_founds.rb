FactoryBot.define do
  factory :case_not_found do
    county { nil }
<<<<<<< Updated upstream
    case_number { "MyString" }
=======
    case_number { 'MyString' }
>>>>>>> Stashed changes
  end
end
