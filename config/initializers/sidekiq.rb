require 'sidekiq/throttled'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'] || 'redis://127.0.0.1:6379' }
end

# Throttle OSCN requests during business hours
OKLAHOMA_DAY_START = Time.parse("02:00 pm UTC")
OKLAHOMA_DAY_END = Time.parse("10:00 pm UTC")
Sidekiq::Throttled::Registry.add(:oscn, **{
  threshold: {
    :limit => ->(*_) {
      Time.now.utc.between?(OKLAHOMA_DAY_START, OKLAHOMA_DAY_END) ? ENV.fetch('OSCN_THROTTLE', 60).to_i : 1_000
    },
    :period => 1.minute
  }
})

Sidekiq::Throttled::Registry.add(:tulsa_city, **{
  threshold: {
    :limit => ->(*_) {
      Time.now.utc.between?(OKLAHOMA_DAY_START, OKLAHOMA_DAY_END) ? 60.to_i : 1_000
    },
    :period => 1.minute
  }
})

Sidekiq::Throttled.setup!
