module Importers
  class StructureFire
    def initialize(data)
      @data = data
    end

    def self.perform(data)
      new(data).perform
    end

    def perform
      puts "result: #{result}"
      result.each do |fire|
        sf = StructureFire.find_or_initialize_by(
          incident_number: fire['Incident Number']
        )
        sf.assign_attributes(
          incident_type: fire['Incident Type'],
          station: fire['Station'],
          incident_date: Date.strptime(fire['Days in Incident Date'], '%m/%d/%y'),
          street_number: fire['Location Street Number or Mile Post'],
          street_prefix: fire['Location Street Prefix'],
          street_name: fire['Location Street or Highway Name'],
          street_type: fire['Location Street Type'],
          property_value: fire['Estimated Property Value'],
          property_loss: fire['Estimated Property Loss'],
          content_value: fire['Estimated Content Value'],
          content_loss: fire['Estimated Content Loss']
        )
        sf.save!
      end
    end
  end
end
