require 'open-uri'

namespace :save do
  desc 'Pull judges for a county'
  task judges: :environment do
    Scrapers::Judges.perform
  end
end
