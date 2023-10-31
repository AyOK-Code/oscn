class AzureCustomExtractor
  # TODO: Configure to accept different extraction models
  attr_reader :url

  def initialize
    @url = url
  end

  def self.perform(url)
    new(url).perform
  end

  def perform
    response = HTTParty.post(request_url, body: request_body, headers: headers)
    if response.code.to_i == 202
      operation_url = response['Operation-Location']
      # Poll the operation URL to get the result
      response = nil
      poll_result = nil
      loop do
        sleep(2)
        response = HTTParty.get(operation_url, headers: headers)
        poll_result = JSON.parse(response.body)
        break if poll_result['status'] != 'running'
      end
      result = {}
      result['analyzeResult']['documents'][0]['fields'].each do |name, field|
        result[name.to_s] = field['valueString']
      end
    end
    result
  end

  private

  def endpoint
    'https://eastus.api.cognitive.microsoft.com/'
  end

  def api_key
    ENV.fetch('AZURE_FORM_API_KEY')
  end

  def model_id
    ENV.fetch('AZURE_FORM_MODEL_ID')
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'Ocp-Apim-Subscription-Key' => api_key
    }
  end

  def request_url
    "#{endpoint}/formrecognizer/documentModels/#{model_id}:analyze?api-version=2023-07-31"
  end

  def request_body
    {
      urlSource: url
    }.to_json
  end
end
