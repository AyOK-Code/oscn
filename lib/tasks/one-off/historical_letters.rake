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
  task :extract, [:count] => [:environment] do |_t, args|
    count = args.count.to_i || 100
    bar = ProgressBar.new(count)

    EvictionLetter.historical.missing_extraction.each_with_index do |letter, i|
      bar.increment!
      EvictionOcr::Extractor.perform(letter.docket_event_link.document.url)
      break if i > count
    end
  end

  desc 'Validate addresses'
  task :validate, [:count] => [:environment] do |_t, args|
    count = args.count || 100
    bar = ProgressBar.new(count)

    EvictionLetter.historical.has_extraction.missing_address_validation.each_with_index do |letter, i|
      bar.increment!
      EvictionOcr::AddressValidator.perform(letter.id)
      break if i > count
    end
  end
end
