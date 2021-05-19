require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Scrape cases data'
  task :case do
    # case_id = Case.with_html.where("case_number LIKE '%CF%'").pluck(:id).sample
    # c = Case.find(case_id)

    c = Case.find_by(case_number: 'CF-2018-1016')

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data
  end

  desc 'Run x cases to check for error'
  task :dry_run do
    docket_event_types = []
    cases = Case.with_html.first(20000)
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      parsed_html = Nokogiri::HTML(c.html)
      parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
      data = parser.build_object
      docket_event_types = docket_event_types + data[:docket_events].map { |c| c[:code] }
      bar.increment!
    end
    ap docket_event_types.uniq
  end
end
