module Importers
  # Saves the Html of a court case to the database
  class CaseHtml
    attr_accessor :case_search, :oscn_id, :county

    def initialize(county_id, oscn_id)
      @oscn_id = oscn_id
      @county = County.find(county_id)
      @case_search = OscnScraper::Requestor::Case.new({ county: county.name, oscn: oscn_id })
    end

    def self.perform(county_id, oscn_id)
      new(county_id, oscn_id).perform
    end

    def perform
      html = case_search.fetch_case_by_number
      save_html(court_case, html)
    end

    private

    def court_case
      ::CourtCase.find_by!(county_id: county.id, oscn_id: oscn_id)
    end

    def save_html(court_case, html)
      court_case.build_case_html unless court_case.case_html
      court_case.case_html.update({
                                    html: html, scraped_at: DateTime.current
                                  })
    end
  end
end
