require 'rails_helper'

RSpec.describe Importers::Pd::Booking do
  describe '#perform' do
    it 'imports the data' do
      file_path = 'spec/fixtures/pd/bookings.json'
      test_data =  File.read(file_path)
      test_json =  JSON.parse(test_data)

      Importers::Pd::Booking.perform(test_json)
      expect(::Pd::Booking.all.size).to eq(1)
    end
  end
end
