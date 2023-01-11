require 'open-uri'
require 'aws-sdk-s3'

namespace :s3 do
  desc 'Pull judges for a county'
  task docket_event_links: :environment do
    
    #Rails.application.config.active_storage.service = :amazon

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


    docket_event_links = ::DocketEventLink.all.where(title:'PDF')

    docket_event_links.each do |event_link|
        #download = open(event_link[:link])
        name = event_link[:id].to_s + '_DEL.pdf'

        next  if event_link.pdf.attached? 
            
        event_link.pdf.attach(io:open(event_link[:link]),filename: name,content_type:'application/pdf')
            sleep 2
        
        #IO.copy_stream(download, name)
        

    end


   

  end
end