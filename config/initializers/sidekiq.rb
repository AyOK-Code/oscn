require 'sidekiq/throttled'
require 'sidekiq-status'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
  Sidekiq::Status.configure_server_middleware config, expiration: 10.minutes
  Sidekiq::Status.configure_client_middleware config, expiration: 10.minutes
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
  Sidekiq::Status.configure_client_middleware config, expiration: 10.minutes
end

# Create oscn throttling strategy
Sidekiq::Throttled::Registry.add(:oscn, {
  threshold: { limit: ENV.fetch('OSCN_THROTTLE', 6).to_i, period: 1.minute },
  concurrency: { limit: ENV.fetch('OSCN_CONCURRENCY', 1).to_i }
})

Sidekiq::Throttled.setup!
