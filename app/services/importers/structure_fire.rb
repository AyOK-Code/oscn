require 'open-uri'
module Importers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFire
    def initialize(url)
      @url = url
    end

    def self.perform
      new(@url).perform
    end

    def perform
      begin
        fire_link = ::StructureFireLink.find_or_initialize_by(url: @url)
        fire_link.save!
        binding.pry
        fire_structure = ::StructureFire.find_or_initialize_by(incident_number: @jsons[1][:incident_number])
        fire_structure.assign_attributes(@jsons[1])
        fire_structure.structure_fire_link = fire_link.id
        fire_structure.save!
      rescue StandardError => e
        puts e
        binding.pry

      end
    end
  end
end
