# Worker that scrapes structure fires for a given date
class EvictionWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :structure_fire

  def perform(date)
    # 
  end
end
