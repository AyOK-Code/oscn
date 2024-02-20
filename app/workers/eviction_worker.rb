# Worker that scrapes the Party page on OSCN
# Ex: https://www.oscn.net/dockets/GetPartyRecord.aspx?db=oklahoma&id=5515773
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
