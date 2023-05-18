require 'importers/court_case'
# Finds the case from the search screen
# Scrapes the case and imports into database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class OneOffCaseWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :medium
  sidekiq_throttle_as :oscn

  def perform(county_name, case_number)
    county = find_county(county_name)
    raise StandardError, 'County not found' if county.nil?

    cc = CourtCase.find_by(county_id: county.id, case_number: case_number)

    if cc.blank?
      ::Scrapers::OneOffCase.perform(county, case_number)
    else
      CourtCaseWorker.set(queue: :default).perform(county.id, case_number, true)
    end
  end

  def find_county(county_name)
    County.find_by(name: county_name)
  end
end
