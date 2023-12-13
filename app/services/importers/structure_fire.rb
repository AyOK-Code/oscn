require 'open-uri'
module Importers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFire
    def initialize(json)
      @json = json

    end

    def self.perform
      new(json).perform
    end

    def perform
       fire_link =  ::StructureFireLink.find_or_initialize_by()
       fire_link.assign_attributes(pdf: json[:pdf])

    end
  end
end
