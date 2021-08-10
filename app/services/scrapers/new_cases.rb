module Scrapers
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
      end
    end

    def date_range
      (days_ago.days.ago.to_date..Date.current.to_date).to_a
    end
  end
end
