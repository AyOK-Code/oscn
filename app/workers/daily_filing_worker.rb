# Worker that scrapes the Daily Filing report
class DailyFilingWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :oscn

  def perform(county, date)
    ::Scrapers::DailyFiling.perform(county, date)
  end
end
