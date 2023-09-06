class OcrPdf
  attr_reader :url, :endpoint, :api_key, :model_id

  def initialize(url)
    @url = url
    @endpoint = "https://eastus.api.cognitive.microsoft.com/"
    @api_key = ENV['AZURE_FORM_API_KEY']
    @model_id = ENV['AZURE_FORM_MODEL_ID']
  end

  def self.perform(url)
    new(url).perform
  end

  def perform
    # Create the request URI
    uri = URI("#{endpoint}/formrecognizer/documentModels/#{model_id}:analyze?api-version=2023-07-31")

    # Create the request header with API key
    headers = {
      'Content-Type' => 'application/json',
      'Ocp-Apim-Subscription-Key' => api_key
    }

    # Create the request body
    request_body = {
      urlSource: url
    }.to_json

    # Send the request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = request_body

    response = http.request(request)
    
    # Parse and print the response
    if response.code.to_i == 202
      operation_url = response['Operation-Location']

      # Poll the operation URL to get the result
      response = nil
      result = nil

      loop do
        sleep(2) # You can adjust the polling interval as needed
        response = http.get(operation_url, headers)
        result = JSON.parse(response.body)
        break if result['status'] != 'running'
      end
      final_result = []
    
      result['analyzeResult']['documents'][0]['fields'].each do |name, field|
        final_result << { name: field['valueString'], confidence: field['confidence'] }
      end
    else
      # TODO: Log to Raygun
      puts "Error #{response.code}: #{response.body}"
    end
  end
end