FactoryBot.define do
  factory :tulsa_blotter_page_htmls do
    html { Faker::HtmlLorem.randomHtml(20, 10) }
  end
end
