module Importers
  class CaseHtml
    attr_accessor :search, :case_number

    def initialize(case_number)
      @search = OscnScraper::Search.new
      @case_number = case_number
    end

    def self.perform(case_number)
      new(case_number).perform
    end

    def perform
      court_case = ::CourtCase.find_by(case_number: case_number)
      return if court_case.nil?

      html = search.fetch_case_by_number(court_case.county.name, case_number)
      save_html(court_case, html)
      sleep 2
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
