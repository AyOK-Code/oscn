require 'uri'
require 'oscn_scraper'

namespace :scrape do
  desc "Scrape cases data"
  task :case_html do
    CaseScraper.perform
  end
end
