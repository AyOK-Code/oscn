class Postgrid
  # TODO: Implement the Postgrid API
  # Postcard
  # https://docs.postgrid.com/#fe8c4cd6-7617-4023-9437-669fa847ccc1
  # Contacts
  # https://docs.postgrid.com/#3ac81e66-c5be-4bb6-93c1-fd8a6f0a24b3

  def initialize
    @api_key = ENV.fetch('POSTGRID_API_KEY', nil)
    @base_url = 'https://api.postgrid.com/print-mail/v1'
    raise ArgumentError, 'Postgrid API key is required' if @api_key.nil?
  end

  def self.post(endpoint, params = {})
    new.post(endpoint, params)
  end

  def self.get(endpoint, params = {})
    new.get(endpoint, params)
  end

  def self.delete(endpoint, params = {})
    new.delete(endpoint, params)
  end

  def get(endpoint, params = {})
    HTTParty.get("#{@base_url}/#{endpoint}", headers: headers, query: params)
  end

  def post(endpoint, params = {})
    HTTParty.post("#{@base_url}/#{endpoint}", headers: headers, body: params)
  end

  def delete(endpoint, params = {})
    HTTParty.delete("#{@base_url}/#{endpoint}", headers: headers, body: params)
  end

  private

  def headers
    {
      'x-api-key' => @api_key
    }
  end
end