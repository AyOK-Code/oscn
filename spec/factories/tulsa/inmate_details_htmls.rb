FactoryBot.define do
  factory :inmate_details_html do
    inmate
    html { Faker::HtmlLorem.randomHtml(20, 10) }
  end
end
