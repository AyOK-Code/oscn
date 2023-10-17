require 'httparty'
# Sends address to Google API for validation

class AddressValidator
  attr_reader :address

  def initialize(address)
    @address = address
  end

  def self.perform(address)
    new(address).perform
  end

  def perform
    data = build_data(address)
    headers = {
      'Content-Type' => 'application/json'
    }

    HTTParty.post(url, body: data.to_json, headers: headers)
  end

  private

  def build_data(address)
    {
        'address' => {
          'regionCode' => 'US',
          'administrativeArea' => 'Oklahoma County',
          'addressLines' => [address]
        }
    }
  end

  def url
    "https://addressvalidation.googleapis.com/v1:validateAddress?key=#{ENV.fetch('GOOGLE_API_KEY', nil)}"
  end
end