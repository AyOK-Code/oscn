# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
#
# if ENV['PROXY_URL']
#   HTTParty::Basement.http_proxy(ENV['PROXY_URL'], ENV.fetch['PROXY_PORT'], nil, nil)
# end
#
