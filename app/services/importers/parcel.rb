require 'csv'
module Importers
  class Parcel
    def initialize(csv_text)
      @csv = CSV.parse(csv_text, headers: true)
      @parcels = []
    end

    def perform
      @csv.each do |row|
        @parcels << save_data(row)
      end
      @parcels.compact!
      ::Parcel.upsert_all(@parcels)
    end

    def save_data(row)
      {
        id: row['parcelnb'],
        geoid20: row['geoid20'],
        zip: row['zip'],
        tract: row['tract'],
        block: row['block'],
        lat: row['lat'],
        long: row['lon']
      }
    end
  end
end
