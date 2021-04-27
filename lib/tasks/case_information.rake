require 'uri'
require 'oscn_scraper'

namespace :scrape do
  desc "Scrape cases data"
  task :case_information do
    # TODO: Change to import task
    scraper = OscnScraper::Search.new
    cases = Case.all
    bar = ProgressBar.new(10000)

    cases.without_html.each_with_index do |c, i|
      county = c.county.name
      number = c.case_number
      puts "Pulling case: #{number} for #{county}"
      html = scraper.fetch_case_by_number(county, number)
      c.update(html: html, scraped_at: Time.current)
      break if i > 10000
      sleep 1
      bar.increment!
    end
  end
end
