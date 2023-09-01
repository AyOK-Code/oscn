FactoryBot.define do
  factory :tulsa_city_offense, class: TulsaCity::Offense do
    bond { 'MyString' }
    court_date { 'MyString' }
    case_number { 'MyString' }
    court_division { 'MyString' }
    hold { 'MyString' }
    docket_id { 'MyString' }
    title { 'MyString' }
    section { 'MyString' }
    paragraph { 'MyString' }
    crime { 'MyString' }
  end
end
