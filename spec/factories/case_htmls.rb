FactoryBot.define do
  factory :case_html do
    court_case
    scraped_at { Faker::Time.between(from: DateTime.now - 100, to: DateTime.now) }
    html { '<div><h1>hello world</h1></div>' }
  end
end
