module Importers
  module Ok2Explore
    class ScrapeJob < ApplicationService
      attr_reader :scrape_job, :bar

      def initialize(scrape_job, bar: false)
        @scrape_job = scrape_job
        @bar = bar
        super()
      end

      def perform
        log "Scraping: #{scrape_job.id}"
        begin
          death_records = ::Ok2explore::Scraper.new(**scraper_args).perform
        rescue ::Selenium::WebDriver::Error::TimeoutError
          log 'Timeout occurred, skipping for now.'
          return nil
        rescue ::Ok2explore::Errors::TooManyResults
          create_smaller_jobs(scrape_job)
          return nil
        end

        begin
          import_death_records(death_records)
        rescue StandardError => e
          log 'Failure on death record import'
          log "message was: #{e}"
          return nil
        end
        scrape_job.update(is_success: true)
      end

      def create_smaller_jobs(scrape_job)
        log 'Too many results. Fanning out to smaller jobs'
        scrape_job.update(is_too_many_records: true)

        ('a'..'z').to_a.each do |added_letter|
          ::Ok2Explore::ScrapeJob.create(
            year: scrape_job.year.to_s,
            month: scrape_job.month.to_s,
            first_name: scrape_job.first_name.to_s,
            last_name: "#{scrape_job.last_name}#{added_letter}"
          )
        end
      end

      def scraper_args
        {
          year: scrape_job.year.to_s,
          month: scrape_job.month.to_s,
          first_name: "#{scrape_job.first_name}*",
          last_name: "#{scrape_job.last_name}*"
        }
      end

      def import_death_records(death_records)
        log "Found #{death_records.count} for scrape job"
        death_records.each do |data|
          ::Importers::Ok2Explore::Death.perform(data)
        end
      end

      def log(message)
        bar ? bar.puts(message) : puts(message)
      end
    end
  end
end
