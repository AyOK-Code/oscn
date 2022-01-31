class Bucket
  attr_accessor :s3

  def initialize
    @s3 = client
  end

  def get_object(filepath)
    s3.get_object(bucket: ENV['BUCKETEER_BUCKET_NAME'], key: filepath)
  end

  private

  def client
    credentials = Aws::Credentials.new(ENV['BUCKETEER_AWS_ACCESS_KEY_ID'], ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'])
    Aws.config.update(
      region: 'us-east-1',
      credentials: credentials
    )
    Aws::S3::Client.new
  end
end
