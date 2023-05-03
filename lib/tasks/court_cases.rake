require 'uri'

namespace :scrape do
  desc 'Scrape cases into database for a given county and'
  task :court_cases, [:year, :county_name, :months] => [:environment] do |_t, args|
    raise StandardError, 'Missing required param: year' if args.year.nil?
    raise StandardError, 'Missing required param: months' if args.months.nil?
    raise StandardError, 'Missing required param: county_name' if args.county_name.nil?

    year = args.year.to_i
    months = args.months.to_i
    county_name = args.county_name
    dates = (Date.new(year, 1, 1)..Date.new(year, months, 31)).to_a
    bar = ProgressBar.new(dates.count)

    dates.each do |date|
      bar.increment!

      DailyFilingWorker
        .set(queue: :high)
        .perform_async(county_name, date)
    end
  end
end
