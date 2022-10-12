require 'aws-sdk-lambda'

class Lambda
  attr_accessor :client

  def initialize
    @client = client
  end

  def call(function, payload)
    payload = JSON.generate(payload)
    resp = client.invoke({
                           function_name: function,
                           invocation_type: 'RequestResponse',
                           log_type: 'None',
                           payload: payload
                         })

    response = JSON.parse(resp.payload.string)

    if response["statusCode"] == 200 && response["body"]["result"] == "success"
      return response["body"]["data"]
    end

    raise StandardError("Lambda Request Failed. Response: #{response}")
  end

  private

  def client
    credentials = Aws::Credentials.new(ENV['AWS_LAMBDA_KEY'], ENV['AWS_LAMBDA_SECRET'])
    Aws::Lambda::Client.new(region: ENV['AWS_LAMBDA_REGION'], credentials: credentials)
  end
end
