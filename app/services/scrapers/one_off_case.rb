module Scrapers
  class OneOffCase
    attr_accessor :county, :case_number, :case_types, :counties

    def initialize(county, case_number)
      @county = county
      @case_number = case_number
      @case_types = CaseType.oscn_id_mapping
      @counties = County.name_id_mapping
    end

    def self.perform(county, date)
      new(county, date).perform
    end

    def perform
      html = OscnScraper::Requestor::Search.fetch_cases({ db: 'all', number: case_number })
      parsed_html = Nokogiri::HTML(html.body)
      data = OscnScraper::Parsers::Search.parse(parsed_html, county.downcase)
      # TODO: DEV-1144 Log if case was not found
      county_id = counties[county]

      data.each do |row|
        case_type = row[:case_number].split('-').first
        next if case_types[case_type].blank?

        c = ::CourtCase.find_or_initialize_by(oscn_id: row[:oscn_id], county_id: county_id)
        c.case_type_id = case_types[case_type]
        c.case_number = row[:case_number]
        c.save!

        ::Importers::CaseHtml.perform(county_id, c.case_number)
        ::Importers::CourtCase.perform(county_id, c.case_number)
      end
    end
  end
end
