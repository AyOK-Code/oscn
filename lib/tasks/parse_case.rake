require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Show results of a single case parsed'
  # TODO: Remove
  task :court_cases do
    court_case_id = CourtCase.valid.find_by(case_number: 'CF-2016-641').id
    c = CourtCase.find(court_case_id)

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data[:docket_events]
  end
end
