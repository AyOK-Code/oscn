require 'uri'

# rubocop:disable Metrics/BlockLength

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
  task :death_records, [:record_count] => [:environment] do |_t, args|
    needs_scraping = Ok2Explore::ScrapeJob.where(is_success: false).sample(args.record_count.to_i)
    needs_scraping.each do |record|
      puts "Scraping: #{record.id}"
      args = {
        year: record.year.to_s,
        month: record.month.to_s,
        first_name: "#{record.first_name}*",
        last_name: "#{record.last_name}*"
      }
      begin
        records = Ok2explore::Scraper.new(**args).perform
      rescue Ok2explore::Errors::TooManyResults
        puts 'Too many results, skipping.'
        record.update(is_too_many_records: true)
        records = nil
      end
      next if records.nil?

      puts "Found #{records.count} records."
      records.each do |data|
        ::Importers::Ok2Explore::Death.perform(data)
      end
      record.update(is_success: true)
    end
  end

  desc 'Populate desired scrapes for deaths'
  task jobs: [:environment] do
    (1980..2018).to_a.each do |year|
      (1..12).to_a.each do |month|
        ('a'..'z').to_a.each do |first_letter|
          ('a'..'z').to_a.each do |last_letter|
            Ok2Explore::ScrapeJob.create(
              year: year,
              month: month,
              first_name: first_letter,
              last_name: last_letter
            )
          end
        end
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength