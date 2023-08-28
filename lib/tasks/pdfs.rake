namespace :save do
  desc 'Update cases for data request'
  task :pdfs, [:count] => [:environment] do |_t, args|
    count = args[:count].to_i
    # rubocop:disable Layout/LineLength
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'
    accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
    # rubocop:enable Layout/LineLength
    puts "Updating #{count} cases"

    links = DocketEventLink
            .without_attached_file
            .pdf
            .joins(:docket_event)
            .where(docket_events: { court_case_id: CourtCase.joins(:report_eviction).pluck(:id) })
            .limit(count)

    links.each do |link|
      puts "Sending request #{link.link}"
      response = HTTParty.get(link.link, headers: {
                                'User-Agent': ENV.fetch('USER_AGENT', user_agent),
                                'Accept-Encoding': 'gzip, deflate, br',
                                'Accept-Language': 'en-US,en;q=0.9,es;q=0.8',
                                Accept: accept
                              })

      puts "Saving #{link.link}"
      link.document.attach(io: StringIO.new(response.body), filename: link.docket_event_id,
                           content_type: 'application/pdf')
      puts "Saved #{link.link}"
      sleep 2
    end
  end
end
