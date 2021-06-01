require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Scrape cases data'
  task :case do
    case_id = Case.with_html.where("case_number LIKE '%CF%'").pluck(:id).sample
    c = Case.find(case_id)

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data
  end

  desc 'Run x cases to check for error'
  task :dry_run do
    events = []
    cases = Case.valid.with_html.first(50000)
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      parsed_html = Nokogiri::HTML(c.html)
      data = OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
      events = events.uniq + data[:docket_events].map { |c| c[:code] }.uniq
      bar.increment!
    end
    ap events.uniq
  end
end
