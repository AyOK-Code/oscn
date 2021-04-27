require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc "Scrape cases data"
  task :case do
    # TODO: Change to import task
    # Get a random case
    case_id = Case.with_html.pluck(:id).sample
    c = Case.find(case_id)
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data
  end
end
