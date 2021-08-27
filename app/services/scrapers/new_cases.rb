module Scrapers
  # Pulls in new cases from OSCN daily filings report
  class NewCases
    attr_reader :case_types, :counties, :days_ago

    def initialize(days_ago)
      @case_types = CaseType.oscn_id_mapping
      @counties = County.pluck(:name, :id).to_h
      @days_ago = days_ago
    end

    def self.perform(days_ago: 7)
      new(days_ago).perform
    end

    def perform
      date_range.each do |date|
        scraper = OscnScraper::Requestor::Report.new({ county: 'Oklahoma', date: date })
        html = scraper.fetch_daily_filings
        data = Nokogiri::HTML(html.body)
        puts "Pulling cases from #{date.strftime('%m/%d/%Y')}"

        data.css('tr a').each do |row|
          save_case(row)
        end
      end
    end

    def save_case(row)
      # TODO: Extract service that takes link and pulls out the params
      params = extract_params(row['href'])
      case_number = row.text
      case_type_id = case_types[case_type(case_number)]
      next if case_type_id.blank?

      c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id)
      c.assign_attributes(
        county_id: counties[county(params)],
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
      params['casemasterID'].first.to_i
    end

    def county(params)
      params['db'].first
    end

    def case_type(case_number)
      case_number.split('-').first
    end

    def date_range
      (days_ago.days.ago.to_date..Date.current.to_date).to_a
    end
  end
end
