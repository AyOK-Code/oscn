require 'openssl'

# There seems to be issues with oscn's ssl certificate
# this only popped up when we added proxy server but *seems* to be happening without the proxy server
# happens intermittently on both heroku and locally
# todo: figure out how we can remove this?
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE