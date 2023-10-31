module EvictionOcr
  class Run
    attr_accessor :eviction_letter

    def initialize(eviction_letter_id)
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
    end

    def self.perform(eviction_letter_id)
      new(eviction_letter_id).perform
    end

    def perform
      [EvictionOcr::Extractor, EvictionOcr::Validator, EvictionOcr::Mailer].each do |action|
        action.perform(eviction_letter.id)
      rescue StandardError => e
        Raygun.track_exception(e)
      end
    end
  end
end
