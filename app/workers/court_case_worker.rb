require 'importers/court_case'
# Worker that scrapes the Case information and updates the database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class CourtCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(args)
    ::Importers::CaseHtml.perform(args['county_id'], args['case_number']) if args['scrape_case']
    ::Importers::CourtCase.perform(args['county_id'], args['case_number'])
  end
end
