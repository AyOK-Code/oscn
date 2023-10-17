module EvictionOcr
  class Validator
    attr_reader :url
    attr_accessor :eviction_letter

    def initialize(eviction_letter_id)
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
    end

    def self.perform(data)
      new(data).perform
    end

    def perform
      response = AddressValidator.perform(eviction_letter.ocr_plaintiff_address)
      
      if response.code.to_i == 200
        parsed_response = JSON.parse(response.body)['result']
        
        eviction_letter.update(new_attributes(parsed_response))
      else
        puts "Error: #{response.code} - #{response.message}"
      end
      sleep 1
    end

    def new_attributes(parsed_response)
      usps = has_usps(parsed_response)
      {
        status: 'validated',
        is_validated: true,
        validation_granularity: granularity(parsed_response),
        validation_unconfirmed_components: has_unconfirmed_components(parsed_response),
        validation_inferred_components: has_inferred_components(parsed_response),
        validation_usps_address: usps ? first_line(parsed_response) : nil,
        validation_usps_state_zip: usps ? cityStateZip(parsed_response) : nil,
        validation_latitude: latitude(parsed_response),
        validation_longitude: longitude(parsed_response)
      }
    end
  
  private

  def granularity(parsed_response)
    parsed_response['verdict']['validationGranularity']
  end

  def has_unconfirmed_components(parsed_response)
    parsed_response['verdict']['hasUnconfirmedComponents']
  end

  def has_inferred_components(parsed_response)
    parsed_response['verdict']['hasInferredComponents']
  end

  def has_usps(parsed_response)
    parsed_response['uspsData'].present?
  end

  def first_line(parsed_response)
    parsed_response['uspsData']['standardizedAddress']['firstAddressLine']
  end

  def cityStateZip(parsed_response)
    parsed_response['uspsData']['standardizedAddress']['cityStateZipAddressLine']
  end

  def latitude(parsed_response)
    parsed_response['geocode']['location']['latitude']
  end

  def longitude(parsed_response)
    parsed_response['geocode']['location']['longitude']
  end
end
end