require 'importers/court_case'
# Worker that scrapes the Case information and updates the database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class DatabaseUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, queue: :medium

  def perform(args)
    ::Importers::CourtCase.perform(args['county_id'], args['case_number'])
  end
end
