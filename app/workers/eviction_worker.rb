# Worker that gets the most recent eviction cases
class EvictionWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5
  sidekiq_throttle_as :eviction_ocr

  def perform(letter_id)
    EvictionOcr::Extractor.perform(letter_id)
    EvictionOcr::Validator.perform(letter_id)
  end
end
