namespace :ocso do
  desc 'Scrape ocso warrant data'
  task daily_import: [:environment] do
    Scrapers::OcsoWarrants.perform
  end
end
