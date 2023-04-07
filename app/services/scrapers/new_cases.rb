module Scrapers
  # Pulls in new cases from OSCN daily filings report
  class NewCases
    attr_reader :case_types, :counties, :county, :days_ago

    def initialize(county, days_ago: 7)
      @case_types = CaseType.oscn_id_mapping
      @counties = County.pluck(:name, :id).to_h
      @county = county
      @days_ago = days_ago
    end

    def self.perform(county, days_ago: 7)
      new(county, days_ago: days_ago).perform
    end

    def perform
      date_range.each do |date|
        scraper = OscnScraper::Requestor::Report.new({ county: county, date: date })
        html = scraper.fetch_daily_filings
        data = Nokogiri::HTML(html.body)
        puts "Pulling cases from #{date.strftime('%m/%d/%Y')}"

        data.css('tr').each do |row|
          save_case(row, date)
        end
      end
    end
    
    def save_case(row, date)
      params = OscnScraper::Parsers::Link.parse(row)

      case_number = params[:case_number]
      case_type_id = case_types[case_type(case_number)]

      return if case_type_id.blank?

      c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id(params), county_id: counties[county_mapping(params)])
      c.assign_attributes(
        case_type_id: case_type_id,
        case_number: case_number,
        filed_on: date
      )

      c.save!
    end

    def extract_params(link)
      uri = URI(link)
      CGI.parse(uri.query)
    end

    def oscn_id(params)
      params[:oscn_id]
    end

    def county_mapping(params)
      params[:county]
    end

    def case_type(case_number)
      case_number.split('-').first
    end

    def date_range
      (days_ago.days.ago.to_date..Date.current.to_date).to_a
    end
  end
end
