require 'csv'
module Importers
    class Parcel
    def initialize(csv_text)
        binding.pry
        @csv = CSV.parse(csv_text, :headers => true)
    end
    def perform
        binding.pry
        csv.each do |row|
            parcel =Parcel.find_or_initialize_by(id:row['parcelnb'])
            parcel.geoid20 = row['geoid20']
            parcel.zip = row['zip']
            parcel.tract = row['tract']
            parcel.block = row['block']
            parcel.lat = row['lat']
            parcel.long = row['long']
            parcel.save!
        end
    end
end
end


