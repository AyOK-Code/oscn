namespace :evictions do
  task :create_letters do
    ReportOklahomaEviction.past_thirty_days.each do |eviction|
      next if eviction.docket_link_id.nil?

      EvictionLetter.find_or_create_by(
        docket_event_link_id: eviction.docket_link_id,
        status: :historical
      )
    end
  end

  task :ocr_extract do
    letters = EvictionLetter.past_thirty_days.historical.missing_extraction
    bar = ProgressBar.new(letters)

    letters.each do |letter|
      bar.increment!
      EvictionOcr::Extractor.perform(letter.id)
    end
  end

  task :ocr_validate do
    letters = EvictionLetter.past_thirty_days.has_extraction.missing_address_validation
    bar = ProgressBar.new(letters)

    letters.each do |letter|
      bar.increment!
      EvictionOcr::Validator.perform(letter.id)
    end
  end
end
