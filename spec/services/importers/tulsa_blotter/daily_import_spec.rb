require 'rails_helper'

RSpec.describe Importers::TulsaBlotter::DailyImport do
  describe '#perform' do
    it 'imports the data' do
      VCR.use_cassette "tulsa_blotter" do
        expect { Importers::TulsaBlotter::DailyImport.perform }
          .to change { ::TulsaBlotter::Arrest.count }
          .and change { ::TulsaBlotter::Offense.count }
      end
    end
  end
end
