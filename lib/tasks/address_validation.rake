require 'net/http'
require 'uri'
require 'json'

namespace :google do
  desc 'Update cases for data request'
  task addresses: [:environment] do
    url = URI.parse("https://addressvalidation.googleapis.com/v1:validateAddress?key=#{ENV.fetch('GOOGLE_API_KEY',
                                                                                                 nil)}")
    # Load csv file from lib/data
    csv = CSV.parse(File.read(Rails.root.join('lib', 'data', 'evictions_result_ocr.csv')), headers: true)
    csv.each do |row|
      address = row['OcrAddress']

      data = {
        'address' => {
          'regionCode' => 'US',
          'administrativeArea' => 'Oklahoma County',
          'addressLines' => [address]
        }
      }

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true # Enable SSL/TLS

      request = Net::HTTP::Post.new(url)
      request.body = data.to_json
      request['Content-Type'] = 'application/json'

      response = http.request(request)

      if response.code.to_i == 200
        parsed_response = JSON.parse(response.body)['result']

        has_usps = parsed_response['uspsData'].present?
        # Add column to csv file
        ap parsed_response
        row['OcrvalidationGranularity'] = parsed_response['verdict']['validationGranularity']
        row['OcrhasUnconfirmedComponents'] = parsed_response['verdict']['hasUnconfirmedComponents']
        row['OcrhasInferredComponents'] = parsed_response['verdict']['hasInferredComponents']
        row['OcrfirstAddressLine'] =
          has_usps ? parsed_response['uspsData']['standardizedAddress']['firstAddressLine'] : nil
        row['OcrcityStateZipAddressLine'] =
          has_usps ? parsed_response['uspsData']['standardizedAddress']['cityStateZipAddressLine'] : nil
        row['Ocrlatitude'] = parsed_response['geocode']['location']['latitude']
        row['Ocrlongitude'] = parsed_response['geocode']['location']['longitude']
        ap row
      else
        puts "Error: #{response.code} - #{response.message}"
      end
      sleep 1
    end
    # Save csv file to lib/data
    File.write(Rails.root.join('lib', 'data', 'evictions_result_final.csv'), csv.to_csv)
  end
end
