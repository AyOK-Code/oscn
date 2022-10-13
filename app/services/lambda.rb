require 'aws-sdk-lambda'

class Lambda
  def call(function_name, payload)
    payload = JSON.generate(payload)
    resp = client.invoke({
                           function_name: function_name,
                           invocation_type: 'RequestResponse',
                           log_type: 'None',
                           payload: payload
                         })

    response = JSON.parse(resp.payload.string)

    return response['body']['data'] if response['statusCode'] == 200 && response['body']['result'] == 'success'

    raise "Lambda Request Failed. Response: #{response}"
  end

  private

  def client
    return @client if @client
    credentials = Aws::Credentials.new(ENV.fetch('AWS_LAMBDA_KEY', nil), ENV.fetch('AWS_LAMBDA_SECRET', nil))
    @client = Aws::Lambda::Client.new(region: ENV.fetch('AWS_LAMBDA_REGION', nil), credentials: credentials,
                            http_read_timeout: 9000)
  end
end
