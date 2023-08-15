FactoryBot.define do
  factory :ok2_explore_scrape_job, class: 'Ok2Explore::ScrapeJob' do
    year { 1 }
    month { 1 }
    first_name { 'MyString' }
    last_name { 'MyString' }
    is_success { false }
  end
end
