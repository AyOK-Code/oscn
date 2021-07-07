module Scrapers
  class NewCases
    attr_reader :case_types, :counties, :date
    attr_accessor :scraper

    def initialize(date)
      @case_types = CaseType.where(abbreviation: CASE_TYPES).pluck(:abbreviation, :id).to_h
      @counties = County.pluck(:name, :id).to_h
      @date = date
      @scraper = OscnScraper::BaseScraper.new
    end

    def self.perform(date)
      new(date).perform
    end

    def perform
      html = scraper.fetch_daily_filings(date)
      data = Nokogiri::HTML(html.body)
      puts "Pulling cases from #{date.strftime('%m/%d/%Y')}"

      data.css('tr a').each do |row|
        uri = URI(row['href'])
        params = CGI.parse(uri.query)
        case_number = row.text
        oscn_id = params['casemasterID'].first.to_i
        county = params['db'].first
        case_type = case_number.split('-').first
        next if case_types[case_type].blank?

        c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id)
        c.assign_attributes(
          county_id: counties[county],
          case_type_id: case_types[case_type],
          case_number: row.text,
          filed_on: date
        )

        c.save!
      end
      sleep 2
    end
  end
end
