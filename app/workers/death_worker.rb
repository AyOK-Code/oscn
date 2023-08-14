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
    rescue Ok2explore::Errors::TooManyResults => e
      days = Date.new(year, month, -1).day

      (1..days).each do |day|
        DeathWorker.perform_async(first_letter, last_letter, year, month, day)
      end
      records = []
    end
    
    records.each do |record|
      ::Importers::Ok2Explore::Death.perform(record)
    end
  end
end
