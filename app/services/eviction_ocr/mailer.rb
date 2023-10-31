module EvictionOcr
  class Mailer
    attr_accessor :postgrid, :eviction_letter

    def initialize(eviction_letter_id)
      @postgrid = Postgrid.new
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
    end

    def self.perform(eviction_letter_id)
      new(eviction_letter_id).perform
    end

    def perform
      response = Postgrid.post('postcards', params)
      if response && response['result'] && response['result']['id']
        eviction_letter.update(status: 'mailed')
      else
        eviction_letter.update(status: 'error')
      end
    end

    def create_postcard
      url = 'postcards'
      response = Postgrid.post(url, params)
      eviction_letter.update(postgrid_id: response['result']['id'], postgrid_sent_to_api_at: DateTime.now)

      if response && response['result'] && response['result']['id']
        eviction_letter.update(status: 'mailed')
      else
        eviction_letter.update(status: 'error')
      end
    end

    def params
      # TODO: Remove Austin after the test case
      {
        to: {
          firstName: eviction_letter.full_name,
          addressLine1: eviction_letter.validation_usps_address + ' ' + eviction_letter.validation_usps_state_zip,
          proviceOrState: 'OK',
          countryCode: 'US'
        },
        from: {
          firstName: 'Oklahoma Evictions',
          addressLine1: '200 S Cincinnati Ave, Tulsa, OK 74103'
        },
        html: "This letter was sent on: #{DateTime.now.strftime('%m/%d/%Y %I:%M%p')}"
      }
    end
  end
end
