module Importers
  # Saves the Html of a court case to the database
  class CaseHtml
    attr_accessor :case_search, :case_number, :counties, :county

    # TODO: Swap out hard coded County
    def initialize(county, case_number)
      @case_number = case_number
      @counties = County.pluck(:name, :id).to_h
      @county = county
      @case_search = OscnScraper::Requestor::Case.new({ county: county, number: case_number })
    end

    def self.perform(county, case_number)
      new(county, case_number).perform
    end

    def perform
      html = case_search.fetch_case_by_number
      Importers::NewCourtCase.new(case_number).perform if court_case.nil?
      save_html(court_case, html)
    end

    private

    def court_case
      ::CourtCase.find_by(county_id: counties[county], case_number: case_number)
    end

    def save_html(court_case, html)
      court_case.build_case_html unless court_case.case_html
      court_case.case_html.update({
                                    html: html, scraped_at: DateTime.current
                                  })
    end
  end
end
