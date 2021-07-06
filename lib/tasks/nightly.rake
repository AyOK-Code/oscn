require 'uri'
require 'oscn_scraper'

namespace :nightly do
  desc "Scrape cases data"
  task :update do
    Scrapers::Case.perform
  end
end
