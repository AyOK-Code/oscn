namespace :evictions do
  task create_letters: :environment do
    ReportOklahomaEviction.past_thirty_days.each do |eviction|
      next if eviction.docket_link_id.nil?

      EvictionLetter.find_or_create_by(
        docket_event_link_id: eviction.docket_link_id,
        status: :historical
      )
    end
  end

  task ocr_extract: :environment do
    letters = EvictionLetter.past_thirty_days.historical.missing_extraction
    bar = ProgressBar.new(letters.count)

    letters.each do |letter|
      bar.increment!
      EvictionOcr::Extractor.perform(letter.id)
    end
  end

  task ocr_validate: :environment do
    letters = EvictionLetter.past_thirty_days.has_extraction.missing_address_validation
    bar = ProgressBar.new(letters.count)

    letters.each do |letter|
      bar.increment!
      EvictionOcr::Validator.perform(letter.id)
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
