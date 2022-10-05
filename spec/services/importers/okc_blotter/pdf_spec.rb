require 'rails_helper'

RSpec.describe Importers::OkcBlotter::Pdf do
  describe '.perform' do
    context 'when there is an existing pdf on the website' do
      it 'saves the data to the database' do
        # to re-record this test you need to have AWS env variables configured
        # most of them are obfuscated in the final vcr (see rails_helper.rb)
        ENV['BUCKETEER_AWS_REGION'] = 'us-west-2'
        VCR.use_cassette "scrape_pdf" do
          expect { Importers::OkcBlotter::Pdf.perform('2022-10-01') }
            .to change { ::OkcBlotter::Pdf.count }
            .and change { ::OkcBlotter::Booking.count }
            .and change { ::OkcBlotter::Offense.count }
        end
      end
    end
  end
end
