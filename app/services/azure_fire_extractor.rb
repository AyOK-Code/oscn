class AzureFireExtractor
  attr_reader :url, :endpoint

  def initialize(url)
    @url = url
    @endpoint = 'https://eastus.api.cognitive.microsoft.com/'
  end

  def self.perform(url)
    new(url).perform
  end

  def perform
    response = HTTParty.post(request_url, body: request_body, headers: headers)
    puts "response code: #{response.code.to_i}"
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
      result = []
      cell_array = poll_result['analyzeResult']['tables'][0]['cells']
      rows_of_data = cell_array.map { |cell| cell['rowIndex'] }.max
      puts "rows_of_data: #{rows_of_data}"
      
      (0..rows_of_data).each do |i|
        next if i.zero?
        puts "index: #{i}"
        row_data = {}
        cell_array.filter{ |cell| cell['rowIndex'] == i }.each_with_index do |cell, index|
          columnIndexes = cell['columnIndex']
          cell_name = cell_array.find { |cell| cell['columnIndex'] == index && (cell['rowIndex']).zero? }['content']
          cell_value = cell_array.find { |cell| cell['columnIndex'] == index && cell['rowIndex'] == i }['content']
          puts "cell_name: #{cell_name}; cell_value: #{cell_value}"
          row_data[cell_name] = cell_value
        end
        result << row_data
      end
    end

    ::Importers::StructureFire.perform(result)
  end

  private

  def endpoint
    'https://eastus.api.cognitive.microsoft.com/'
  end

  def api_key
    ENV.fetch('AZURE_FORM_API_KEY')
  end

  def model_id
    ENV.fetch('AZURE_STRUCTURE_FIRE_MODEL_ID')
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
