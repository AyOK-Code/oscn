module Importers
  # Saves the Html of a court case to the database
  class CaseHtml
    attr_accessor :case_search, :case_number, :county

    # TODO: Swap out hard coded County
    def initialize(case_number)
      @case_number = case_number
      @county = 'Oklahoma'
      @case_search = OscnScraper::Requestor::Case.new({ county: county, number: case_number })
    end

    def self.perform(case_number)
      new(case_number).perform
    end

    def perform
      court_case = ::CourtCase.find_by(case_number: case_number)
      html = case_search.fetch_case_by_number
      if court_case.nil?
        Importers::NewCourtCase.new(case_number).perform
        court_case = ::CourtCase.find_by(case_number: case_number)
      end
      save_html(court_case, html)
    end

    private

    def save_html(court_case, html)
      court_case.build_case_html unless court_case.case_html
      court_case.case_html.update({
                                    html: html, scraped_at: DateTime.current
                                  })
    end
  end
end
