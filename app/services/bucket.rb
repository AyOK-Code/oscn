class Bucket
  attr_accessor :s3

  def initialize
    @s3 = client
  end

  def put_object(filepath, buffer)
    s3.put_object(bucket: ENV.fetch('BUCKETEER_BUCKET_NAME', nil), key: filepath, body: buffer)
  end

  def get_object(filepath)
    s3.get_object(bucket: ENV.fetch('BUCKETEER_BUCKET_NAME', nil), key: filepath)
  end

  private

  def client
    credentials = Aws::Credentials.new(ENV.fetch('BUCKETEER_AWS_ACCESS_KEY_ID', nil),
                                       ENV.fetch('BUCKETEER_AWS_SECRET_ACCESS_KEY', nil))
    Aws.config.update(
      region: ENV.fetch('BUCKETEER_AWS_REGION', 'us-east-1'),
      credentials:
    )
    Aws::S3::Client.new
  end
end
