require 'importers/court_case'
# Finds the case from the search screen
# Scrapes the case and imports into database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class OneOffCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :medium
  sidekiq_throttle_as :oscn

  def perform(county, case_number)
    ::Scrapers::OneOffCase.perform(county, case_number)
  end
end
