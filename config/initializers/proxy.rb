if ENV['PROXY_HOST']
  HTTParty::Basement.http_proxy(
    ENV['PROXY_HOST'],
    ENV['PROXY_PORT'],
    ENV.fetch('PROXY_USER', nil),
    ENV.fetch('PROXY_PASS', nil)
  )
end

