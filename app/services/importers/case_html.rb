module Importers
  # Saves the Html of a court case to the database
  class CaseHtml
    attr_accessor :case_search, :case_number, :county

    def initialize(county_id, case_number)
      @case_number = case_number
      @county = County.find(county_id)
      @case_search = OscnScraper::Requestor::Case.new({ county: county.name, number: case_number })
    end

    def self.perform(county_id, case_number)
      new(county_id, case_number).perform
    end

    def perform
      html = case_search.fetch_case_by_number
      Importers::NewCourtCase.new(case_number).perform if court_case.nil?
      save_html(court_case, html)
    end

    private

    def court_case
      ::CourtCase.find_by(county_id: county.id, case_number: case_number)
    end

    def save_html(court_case, html)
      court_case.build_case_html unless court_case.case_html
      court_case.case_html.update({
                                    html: html, scraped_at: DateTime.current
                                  })
    end
  end
end
