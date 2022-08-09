require 'slowweb'
# todo: there is a bug where this is only called half as many times
limit = ENV.fetch('OSCN_REQUESTS_PER_MINUTE', 6)*2
SlowWeb.limit('www.oscn.net', limit, 60)