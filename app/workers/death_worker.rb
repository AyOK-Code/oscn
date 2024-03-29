class DeathWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :medium
  sidekiq_throttle_as :ok2explore

  def perform(first_letter, last_letter, year, month, day = '')
    args = {
      year: year.to_s,
      month: month.to_s,
      day: day.to_s,
      first_name: "#{first_letter}*",
      last_name: "#{last_letter}*"
    }
    begin
      records = Ok2explore::Scraper.new(**args).perform
    rescue Ok2explore::Errors::TooManyResults
      days_of_month = Date.new(year, month, -1).day

      (1..days_of_month).each do |day_of_month|
        DeathWorker.perform_async(first_letter, last_letter, year, month, day_of_month)
      end
      records = []
    end

    records.each do |record|
      ::Importers::Ok2Explore::Death.perform(record)
      if ['', 'z'].include?(day)
        Ok2Explore::ScrapeJob.find_by(year: year, month: month, first_name: first_letter,
                                      last_name: last_letter).update!(is_success: true)
      end
    end
  end
end
