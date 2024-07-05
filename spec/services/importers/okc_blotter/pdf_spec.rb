require 'rails_helper'

RSpec.describe Importers::OkcBlotter::Pdf do
  describe '.perform' do
    context 'when there is an existing pdf on the website' do
      it 'saves the data to the database' do
        # to re-record this test you need to have AWS env variables configured
        # most of them are obfuscated in the final vcr (see rails_helper.rb)
        ENV['BUCKETEER_AWS_REGION'] = 'us-west-2'
        ENV['BUCKETEER_BUCKET_NAME'] = 'bucket-name' # aws s3 changes behavior if bucket is uppercase or has underscores
        VCR.use_cassette 'scrape_pdf' do
          Importers::OkcBlotter::Pdf.perform('2022-10-20')
          expect(OkcBlotter::Pdf.count).to be > 0
          expect(OkcBlotter::Booking.count).to be > 0
          expect(OkcBlotter::Offense.count).to be > 0
        end
      end
    end
  end
end
