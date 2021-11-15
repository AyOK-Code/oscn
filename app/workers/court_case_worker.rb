require 'importers/court_case'
# Worker that scrapes the Case information and updates the database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class CourtCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(county, case_number, scrape_case = true)
    ::Importers::CaseHtml.perform(county, case_number) if scrape_case
    ::Importers::CourtCase.perform(county, case_number)
  end
end
