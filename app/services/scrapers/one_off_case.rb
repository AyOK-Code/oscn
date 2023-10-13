module Scrapers
  class OneOffCase
    attr_accessor :county, :case_number, :case_types

    def initialize(county, case_number)
      @county = county
      @case_number = case_number
      @case_types = CaseType.oscn_id_mapping
      @county = County.find_by(name: county)
    end

    def self.perform(county, case_number)
      new(county, case_number).perform
    end

    def perform
      check_not_found = CaseNotFound.find_by(county_id: county.id, case_number: case_number)

      return if check_not_found.present?

      parsed_html = scrape_html
      data = parse_html(parsed_html)

      create_missing_case if data.empty?

      data.each do |row|
        case_type_id = find_case_type(row)
        next if case_type_id.blank?

        create_court_case(row, case_type_id)

        ::Importers::CaseHtml.perform(county.id, case_number)
        ::Importers::CourtCase.perform(county.id, case_number)
      end
    end

    private

    def scrape_html
      html = OscnScraper::Requestor::Search.fetch_cases({ db: 'all', number: case_number })
      Nokogiri::HTML(html.body)
    end

    def parse_html(html)
      OscnScraper::Parsers::Search.parse(html, county.name.downcase)
    end

    def create_missing_case
      CaseNotFound.find_or_create_by(county_id: county.id, case_number: case_number)
    end

    def find_case_type(row)
      case_type = row[:case_number].split('-').first
      case_types[case_type]
    end

    def create_court_case(row, case_type_id)
      c = ::CourtCase.find_or_initialize_by(oscn_id: row[:oscn_id], county_id: county.id)
      c.case_type_id = case_type_id
      c.case_number = row[:case_number]
      c.save!
    end
  end
end
