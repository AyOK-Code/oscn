require 'httparty'

module EvictionOcr
  class Extractor
    attr_accessor :eviction_letter
    attr_reader :url, :endpoint, :api_key, :model_id

    def initialize(eviction_letter_id)
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
      @url = 'https://oklahomaevictions.blob.core.windows.net/ok-pdfs-250/1055278988-20230726-090120-.pdf' # eviction_letter.docket_event_link.document.url
      @endpoint = 'https://eastus.api.cognitive.microsoft.com/'
      @api_key = ENV.fetch('AZURE_FORM_API_KEY')
      
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
        # TODO: Log to Raygun
        puts "Error #{response.code}: #{response.body}"
      end
    end
  end
end
