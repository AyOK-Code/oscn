require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Scrape cases data'
  task :case do
    case_id = Case.with_html.where("case_number LIKE '%CF%'").pluck(:id).sample
    c = Case.find(case_id)

    # c = Case.find_by(case_number: 'CF-2018-1016')

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data
  end

  desc 'Run x cases to check for error'
  task :dry_run do
    party_types = []
    cases = Case.valid.with_html.first(40000)
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      parsed_html = Nokogiri::HTML(c.html)
      data = OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
      party_types = party_types.uniq + data[:parties].map { |c| c[:party_type] }.uniq
      bar.increment!
    end
    ap party_types.sort.uniq
  end
end
