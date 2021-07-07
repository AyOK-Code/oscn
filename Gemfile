source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'awesome_print'
gem 'aws-sdk-s3', '~> 1'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'fuzzy_match'
gem 'httparty'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.7'
gem 'jwt'
gem 'kaminari'
gem 'oscn_scraper', path: '~/code/oscn_scraper'
gem 'monetize'
gem 'pg', '>= 0.18', '< 2.0'
gem 'progress_bar'
gem 'puma', '~> 4.1'
gem 'pundit'
gem 'rack-cors'
gem 'rails'
gem 'redis', '~> 4.0'
gem 'ruby-limiter'
gem 'scenic'
gem 'sidekiq'
gem 'sidekiq-throttled'
gem 'slack-ruby-client'

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'rspec-rails'
  gem 'rubocop', '~> 1.12'
  gem 'rubocop-rails', '~> 2.9'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  gem 'rails-erd'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
