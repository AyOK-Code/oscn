namespace :evictions do
  task create_letters: :environment do
    ReportOklahomaEviction.past_thirty_days.each do |eviction|
      next if eviction.docket_link_id.nil?

      eviction_letter = EvictionLetter.find_or_initialize_by(
        docket_event_link_id: eviction.docket_link_id
      )
      next if eviction_letter.status.in?(%w[extracted validated mailed])
      next if eviction_letter.eviction_file_id.present?

      eviction_letter.status = 'historical'
      eviction_letter.save
    end
  end

  task :eviction_file, [:date] => [:environment] do |_t, args|
    date = args[:date].to_date
    EvictionFileGenerator.generate(date)
  end

  task ocr_nightly: :environment do
    letters = EvictionLetter.past_thirty_days.historical.missing_extraction
    bar = ProgressBar.new(letters.count)

    letters.each do |letter|
      bar.increment!
      EvictionWorker.perform_async(letter.id)
    end
  end

  task add_additional_data_points: :environment do
    letters = EvictionLetter.where("validation_object != '{}'")
    bar = ProgressBar.new(letters.count)

    letters.each do |letter|
      bar.increment!
      ev = EvictionOcr::Validator.new(letter.id)
      attributes = ev.new_attributes(ev.eviction_letter.validation_object)
      letter.update(attributes) if attributes.present?
    end
  end
end
