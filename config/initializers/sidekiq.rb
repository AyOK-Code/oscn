require 'sidekiq/throttled'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
end

# Create oscn throttling strategy
Sidekiq::Throttled::Registry.add(:oscn, {
  threshold: { limit: ENV.fetch('OSCN_THROTTLE', 6).to_i, period: 1.minute },
  concurrency: { limit: ENV.fetch('OSCN_CONCURRENCY', 1).to_i }
})

Sidekiq::Throttled.setup!
