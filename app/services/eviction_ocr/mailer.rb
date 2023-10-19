module EvictionOcr
  class Mailer
    attr_accessor :postgrid, :eviction_letter

    def initialize(eviction_letter_id)
      @postgrid = Postgrid.new(ENV.fetch('POSTGRID_API_KEY', nil))
      @eviction_letter = EvictionLetter.find(eviction_letter_id)
    end

    def self.perform
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
      eviction_letter.update(postgrid_id: response['result']['id'])

      if response && response['result'] && response['result']['id']
        eviction_letter.update(status: 'mailed')
      else
        eviction_letter.update(status: 'error')
      end
    end

    def params
      {
        to: {
          firstName: 'John',
          lastName: 'Doe',
          addressLine1: '123 Main St',
          countryCode: 'US'
        },
        from: 1,
        frontTemplate: 1,
        backTemplate: 1,
        express: true,
      }
    end

  end
end