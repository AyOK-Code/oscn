source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'awesome_print'
gem 'aws-sdk-s3', '~> 1'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'fuzzy_match'
gem 'httparty'
gem 'image_processing', '~> 1.12'
gem 'jbuilder', '~> 2.7'
gem 'jwt'
gem 'kaminari'
gem 'monetize'
gem 'oscn_scraper', git: 'https://github.com/AyOK-Code/oscn_scraper', ref: '262757c'
gem 'pg', '>= 0.18', '< 2.0'
gem 'progress_bar'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 6.0.3'
gem 'rails_autoscale_agent'
gem 'redis', '~> 4.0'
gem 'ruby-limiter'
gem 'scenic'
gem 'sidekiq'
gem 'sidekiq-throttled'
gem 'slack-ruby-client'
gem 'slowweb'

group :development, :test do
  gem 'bullet'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.12'
  gem 'rubocop-rails', '~> 2.9'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'simplecov-json'
end

group :development do
  gem 'rails-erd'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
