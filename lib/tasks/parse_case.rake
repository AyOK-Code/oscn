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

  desc 'Get case changes'
  task :changes do
    scraper = OscnScraper::BaseScraper.new
    request = scraper.events_scheduled('Oklahoma', 31, '06/01/2021') # 31 = CF
    parsed_html = Nokogiri::HTML(request.body)
    search = OscnScraper::Search.new
    data = OscnScraper::Parsers::CaseChanges.new(parsed_html).parse

    bar = ProgressBar.new(data.count)

    data.each do |case_number|
      c = Case.find_by(case_number: case_number)
      if c.nil?
        puts "Case not found in database: #{case_number}"
        bar.increment!
      else
        puts "Pulling case: #{c.case_number} for #{c.county.name}"
        html = search.fetch_case_by_number(c.county.name, c.case_number)
        c.update(html: html, scraped_at: Time.current)
        bar.increment!
      end
    end
  end
end
