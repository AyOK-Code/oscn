namespace :save do
  desc 'Update cases for data request'
  task :pdfs, [:count] => [:environment] do |_t, args|
    count = args[:count].to_i
    puts "Updating #{count} cases"

    links = DocketEventLink
            .without_attached_file
            .pdf
            .joins(:docket_event)
            .where(docket_events: { court_case_id: CourtCase.joins(:report_eviction).pluck(:id) })
            .order('docket_events.event_on DESC')
            .limit(count)

    links.each do |link|
      puts "Sending request #{link.link}"
      response = OscnRequestor.perform(link.link)
      puts "Saving #{link.link}"
      link.document.attach(io: StringIO.new(response.body), filename: link.docket_event_id,
                           content_type: 'application/pdf')
      puts "Saved #{link.link}"
    end
  end
end
