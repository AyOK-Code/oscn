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

  desc 'Scrape death records'
  task :death_records, [:record_limit] => [:environment] do |_t, args|
    ::Importers::Ok2Explore::ScrapePendingJobs.perform(args.record_limit)
  end

  desc 'Populate desired scrapes for deaths'
  task :jobs, [:year] => [:environment] do |_t, args|
    (1..12).to_a.each do |month|
      ('a'..'z').to_a.each do |first_letter|
        ('a'..'z').to_a.each do |last_letter|
          Ok2Explore::ScrapeJob.create(
            year: args.year,
            month: month,
            first_name: first_letter,
            last_name: last_letter
          )
        end
      end
    end
  end
end
