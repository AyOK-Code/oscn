class Postgrid
  def initialize
    @api_key = ENV.fetch('POSTGRID_API_KEY')
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
