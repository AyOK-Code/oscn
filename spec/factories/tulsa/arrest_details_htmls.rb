FactoryBot.define do
  factory :tulsa_blotter_arrest_details_html do
    arrest
    scraped_at { Faker::Time }
    html { Faker::HtmlLorem.randomHtml(20, 10) }
  end
end
