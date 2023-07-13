module Scrapers
  class DailyFiling
    attr_accessor :county_name, :date, :case_types, :counties

    def initialize(county_name, date)
      @county_name = county_name
      @date = date
      @case_types = CaseType.oscn_id_mapping
      @counties = County.name_id_mapping
    end

    def self.perform(county_name, date)
      new(county_name, date).perform
    end

    def perform
      data = fetch_html
      data.css('tr a').each do |row|
        # TODO: Change to use link parser when merged
        # https://github.com/AyOK-Code/oscn_scraper/pull/31
        uri = URI(row['href'])
        params = CGI.parse(uri.query)
        case_number = row.text
        oscn_id = params['casemasterID'].first.to_i
        county = params['db'].first
        case_type = case_number.split('-').first
        next if case_types[case_type].blank?

        c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id, county_id: counties[county])
        c.case_type_id = case_types[case_type]
        c.case_number = row.text
        c.filed_on = date
        c.save!
      end
    end

    private

    def fetch_html
      scraper = OscnScraper::Requestor::Report.new({ county: county_name, date: date })
      html = scraper.fetch_daily_filings
      Nokogiri::HTML(html.body)
    end
  end
end
