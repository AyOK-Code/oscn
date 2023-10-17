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

  def get(endpoint, params = {})
    HTTParty.get(url, headers: {}, query: params)
  end

  def post(endpoint, params = {})
    HTTParty.post(url, headers: {}, body: params)
  end

  def delete(endpoint, params = {})
    HTTParty.delete(url, headers: {}, body: params)
  end
end