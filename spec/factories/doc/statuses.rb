FactoryBot.define do
  factory :doc_status, class: 'Doc::Status' do
    doc_profile { nil }
    facility { 'Location' }
    date { Faker::Date.between(from: 1.year.ago, to: Date.current) }
    reason { Faker::Lorem.sentence }
  end
end
