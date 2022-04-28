module Scrapers
  class Events
    attr_accessor :base_url

    def initialize
      @base_url = 'https://www.oscn.net/applications/oscn/report.asp?report=WebJudicialDocketEventAll'
    end

    def self.perform
      new.perform
    end

    def perform
      data = JSON.parse(File.open('lib/data/events.json').read)
      data.each do |o|
        e = EventType.find_or_initialize_by(oscn_id: o['oscn_id'])
        e.code = o['code']
        e.name = o['name']
        e.save!
      end
    end
  end
end
