require 'rails_helper'

RSpec.describe Importers::TulsaBlotter::DailyImport do
  describe '#perform' do
    it 'imports the data' do
      expect { subject.perform('2022-10-11') }
        .to change { ::TulsaBlotter::Inmate.count }
        .and change { ::TulsaBlotter::Booking.count }
        .and change { ::TulsaBlotter::Offense.count }
    end
  end
end
