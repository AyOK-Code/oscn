require 'httparty'

module EvictionOcr
  class Extractor
    attr_accessor :eviction_letter
    attr_reader :url, :endpoint, :api_key, :model_id

    def initialize(eviction_letter_id)
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
      @url = 'https://oklahomaevictions.blob.core.windows.net/ok-pdfs-250/1055278988-20230726-090120-.pdf' # eviction_letter.docket_event_link.document.url
      @endpoint = 'https://eastus.api.cognitive.microsoft.com/'
      @api_key = ENV.fetch('AZURE_FORM_API_KEY', nil)
      @model_id = ENV.fetch('AZURE_FORM_MODEL_ID', nil)
    end

    def self.perform(url)
      new(url).perform
    end

    def perform
      request_url = "#{endpoint}/formrecognizer/documentModels/#{model_id}:analyze?api-version=2023-07-31"
      headers = {
        'Content-Type' => 'application/json',
        'Ocp-Apim-Subscription-Key' => api_key
      }
      request_body = {
        urlSource: url
      }.to_json

      # Send the request using HTTParty
      response = HTTParty.post(request_url, body: request_body, headers: headers)

      # Parse and print the response
      if response.code.to_i == 202
        operation_url = response['Operation-Location']
        
        # Poll the operation URL to get the result
        response = nil
        result = nil
        loop do
          sleep(2) # You can adjust the polling interval as needed
          response = HTTParty.get(operation_url, headers: headers)
          result = JSON.parse(response.body)
          break if result['status'] != 'running'
        end
        final_result = {}
        result['analyzeResult']['documents'][0]['fields'].each do |name, field|
          final_result["#{name}"] = field['valueString']
        end
        eviction_letter.update(
            status: 'extracted',
            ocr_plaintiff_address: final_result['plaintiff_address'],
            ocr_agreed_amount: final_result['agreed_amount'],
            ocr_default_amount: final_result['default_amount'],
            ocr_plaintiff_phone_number: final_result['plaintiff_phone_number']
          )
      else
        # TODO: Log to Raygun
        puts "Error #{response.code}: #{response.body}"
      end
    end
  end
end
