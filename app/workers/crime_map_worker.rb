class CrimeMapWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 3, queue: :medium
  sidekiq_throttle_as :crime_map_worker

  def perform
    date_range = (Date.parse(ENV.fetch('LEXUS_NEXUS_START', '2000-01-01'))..(Time.zone.now - 1.week)).step(3)
    bar = ProgressBar.new(date_range.count)
    date_range.each do |date|
      bar.increment!
      start_date = date
      end_date = date + 3.days
      Importers::CrimeMap.perform(start_date, end_date)
    end
  end
end
