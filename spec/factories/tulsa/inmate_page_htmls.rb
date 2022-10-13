FactoryBot.define do
  factory :inmate_page_html do
    html { Faker::HtmlLorem.randomHtml(20, 10) }
    inmates { [FactoryGirl.create(:inmate)] }
  end
end
