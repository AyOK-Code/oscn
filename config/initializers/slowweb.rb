require 'slowweb'
# todo: there is a bug where this is only called half as many times
oscn_limit = ENV.fetch('OSCN_REQUESTS_PER_MINUTE', 12).to_i*2
SlowWeb.limit('www.oscn.net', oscn_limit, 60)
ocso_limit = ENV.fetch('OCSO_REQUESTS_PER_MINUTE', 12).to_i*2
SlowWeb.limit('docs.oklahomacounty.org', ocso_limit, 60)