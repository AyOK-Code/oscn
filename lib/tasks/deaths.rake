require 'uri'

namespace :scrape do
  desc 'Scrape cases into database for a given county and'
  task :deaths, [:start_year, :end_year] => [:environment] do |_t, args|
    raise StandardError, 'Missing required param: start_year' if args.start_year.nil?
    raise StandardError, 'Missing required param: end_year' if args.end_year.nil?

    start_year = args.start_year.to_i
    end_year = args.end_year.to_i

    (start_year..end_year).to_a.each do |year|
      Scrapers::Ok2Explore::Deaths.perform(year)
    end
  end
end
