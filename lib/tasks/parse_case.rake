require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Show results of a single case parsed'
  # TODO: Remove
  task :court_cases do
    court_case_id = CourtCase.with_html.where("case_number LIKE '%CF%'").pluck(:id).sample
    c = CourtCase.find(case_id)

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data
  end

  # TODO: Move to class that is part of nightly update
  desc 'Get case changes based on the daily docket'
  task :changes do
    scraper = OscnScraper::BaseScraper.new
    request = scraper.events_scheduled('Oklahoma', 31, '06/01/2021') # 31 = CF
    parsed_html = Nokogiri::HTML(request.body)
    search = OscnScraper::Search.new
    data = OscnScraper::Parsers::CaseChanges.new(parsed_html).parse

    bar = ProgressBar.new(data.count)

    data.each do |case_number|
      c = CourtCase.find_by(case_number: case_number)
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
