FactoryBot.define do
  factory :parcel do
    geoid20 { 'MyString' }
    zip { 'MyString' }
    tract { '' }
    block { 'MyString' }
    lat { '9.99' }
    long { '9.99' }
  end
end
