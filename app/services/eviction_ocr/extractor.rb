require 'httparty'

module EvictionOcr
  class Extractor
    attr_accessor :eviction_letter
    attr_reader :url, :endpoint, :model_id

    def initialize(eviction_letter_id)
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
      @url = eviction_letter.docket_event_link.document.url
      @endpoint = 'https://eastus.api.cognitive.microsoft.com/'
    end

    def self.perform(url)
      new(url).perform
    end

    def perform
      result = AzureCustomExtractor.perform(url)
      if result
        eviction_letter.update(
          status: 'extracted',
          ocr_plaintiff_address: result['plaintiff_address'],
          ocr_agreed_amount: result['agreed_amount'],
          ocr_default_amount: result['default_amount'],
          ocr_plaintiff_phone_number: result['plaintiff_phone_number']
        )
      else
        Raygun.track_exception(
          StandardError.new('AzureCustomExtractor returned nil'),
          custom_data: { url: url, eviction_letter_id: eviction_letter.id, model_id: model_id }
        )
      end
    end
  end
end
