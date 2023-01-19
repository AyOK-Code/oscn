require 'importers/court_case'
# Worker that scrapes the Case information and updates the database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class CourtCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :medium
  sidekiq_throttle_as :oscn 

  def perform(county_id, oscn, scrape_case)
    ::Importers::CaseHtml.perform(county_id, oscn) if scrape_case
    ::Importers::CourtCase.perform(county_id, oscn)
  end
end
