FactoryBot.define do
  factory :case_html do
    court_case { nil }
    scraped_at { "2021-06-10 12:12:53" }
    html { "MyText" }
  end
end
