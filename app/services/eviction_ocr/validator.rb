module EvictionOcr
  # rubocop:disable Metrics/ClassLength
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
        eviction_letter.update(validation_object: parsed_response)
        attributes = new_attributes(parsed_response)
        eviction_letter.update(attributes) if attributes.present?
      else
        Raygun.track_exception(
          StandardError.new('AddressValidator returned a non-200 response'),
          custom_data: { eviction_letter_id: eviction_letter.id, response: response }
        )
      end
    end

    def new_attributes(parsed_response)
      define_attributes(parsed_response)
    rescue StandardError => e
      @eviction_letter.update(status: :error)
      Raygun.track_exception(e,
                             custom_data: { eviction_letter_id: eviction_letter.id,
                                            parsed_response: parsed_response })
      nil
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def define_attributes(parsed_response)
      usps = parsed_response['uspsData'].present?
      meta = parsed_response['metadata'].present?
      {
        status: 'validated',
        is_validated: true,
        validation_granularity: granularity(parsed_response),
        validation_unconfirmed_components: unconfirmed_components?(parsed_response),
        validation_inferred_components: inferred_components?(parsed_response),
        validation_usps_address: usps ? usps_first_line(parsed_response) : first_line(parsed_response),
        validation_usps_state_zip: usps ? usps_city_state_zip(parsed_response) : city_state_zip(parsed_response),
        validation_latitude: latitude(parsed_response),
        validation_longitude: longitude(parsed_response),
        validation_city: usps ? usps_city(parsed_response) : city(parsed_response),
        validation_state: usps ? usps_state(parsed_response) : state(parsed_response),
        validation_zip_code: usps ? usps_zip(parsed_response) : zip_code(parsed_response),
        is_metadata_present: meta,
        is_po_box: meta ? parsed_response['metadata']['poBox'] || false : false,
        is_business: meta ? parsed_response['metadata']['business'] || false : false,
        is_residential: meta ? parsed_response['metadata']['residential'] || false : false
      }
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def granularity(parsed_response)
      parsed_response['verdict']['validationGranularity']
    end

    def unconfirmed_components?(parsed_response)
      parsed_response['verdict']['hasUnconfirmedComponents']
    end

    def inferred_components?(parsed_response)
      parsed_response['verdict']['hasInferredComponents']
    end

    def usps_first_line(parsed_response)
      parsed_response['uspsData']['standardizedAddress']['firstAddressLine']
    end

    def usps_city(parsed_response)
      parsed_response['uspsData']['standardizedAddress']['city']
    end

    def usps_state(parsed_response)
      parsed_response['uspsData']['standardizedAddress']['state']
    end

    def usps_zip(parsed_response)
      parsed_response['uspsData']['standardizedAddress']['zipCode']
    end

    def usps_city_state_zip(parsed_response)
      parsed_response['uspsData']['standardizedAddress']['cityStateZipAddressLine']
    end

    def first_line(parsed_response)
      parsed_response['address']['postalAddress']['addressLines'][0]
    end

    def city_state_zip(parsed_response)
      city = parsed_response['address']['postalAddress']['locality']
      state = parsed_response['address']['postalAddress']['administrativeArea']
      zip = parsed_response['address']['postalAddress']['postalCode']
      "#{city} #{state} #{zip}"
    end

    def city(parsed_response)
      parsed_response['address']['postalAddress']['locality']
    end

    def state(parsed_response)
      parsed_response['address']['postalAddress']['administrativeArea']
    end

    def zip_code(parsed_response)
      parsed_response['address']['postalAddress']['postalCode']
    end

    def latitude(parsed_response)
      parsed_response['geocode']['location']['latitude']
    end

    def longitude(parsed_response)
      parsed_response['geocode']['location']['longitude']
    end
  end
  # rubocop:enable Metrics/ClassLength
end
