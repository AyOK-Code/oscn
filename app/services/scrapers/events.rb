module Scrapers
  # TODO: Pull data using OSCN scraper gem
  class Events
    attr_accessor :data

    def initialize
      @file = Bucket.new.get_object('events.json')
      @data = JSON.parse(@file.body.read)
    end

    def self.perform
      new.perform
    end

    def perform
      data.each do |o|
        e = EventType.find_or_initialize_by(oscn_id: o['oscn_id'])
        e.code = o['code']
        e.name = o['name']
        e.save!
      end
    end
  end
end
