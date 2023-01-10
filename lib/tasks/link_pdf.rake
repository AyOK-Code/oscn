require 'open-uri'
require 'aws-sdk-s3'

namespace :s3 do
  desc 'Pull judges for a county'
  task docket_event_links: :environment do
    
    

    credentials = Aws::Credentials.new(ENV.fetch('ASPIRING_AWS_KEY_ID', nil),
                                       ENV.fetch('ASPIRING_SECRET_ACCESS_KEY', nil))
    Aws.config.update(
      region: ENV.fetch('ASPIRING_AWS_REGION', 'us-east-1'),
      credentials: credentials
    )
    client = Aws::S3::Client.new
    #filepath 
    #bucket = client.get_object(bucket: ENV.fetch('BUCKETEER_BUCKET_NAME', nil), key: filepath)
    response = client.list_objects_v2(bucket: ENV.fetch('ASPIRING_BUCKET_NAME', nil))

    binding.pry

  end
end