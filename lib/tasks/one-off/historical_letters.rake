require 'open-uri'

namespace :historical do
  desc 'Populates historical eviction pdfs'
  task :letters, [:year] => [:environment] do |_t, args|
    ReportOklahomaEviction.filed_year(args.year).each do |r|
      EvictionLetter.find_or_create_by(
        docket_event_link_id: r.docket_link_id,
        status: :historical
      )
    end
  end

  desc 'Extracts historical eviction pdfs'
  task :extract, [:pdf_count] => [:environment] do |_t, args|
    count = args.pdf_count.to_i
    bar = ProgressBar.new(count)

    EvictionLetter.historical.missing_extraction.each_with_index do |letter, i|
      bar.increment!
      EvictionOcr::Extractor.perform(letter.id)
      break if i > count
    end
  end

  desc 'Validate addresses'
  task :validate, [:pdf_count] => [:environment] do |_t, args|
    count = args.pdf_count.to_i
    bar = ProgressBar.new(count)

    EvictionLetter.historical.has_extraction.missing_address_validation.each_with_index do |letter, i|
      bar.increment!
      EvictionOcr::AddressValidator.perform(letter.id)
      break if i > count
    end
  end
end
