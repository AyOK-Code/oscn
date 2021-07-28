namespace :save do
  desc 'Scrape court_cases data'
  task court_cases: [:environment] do
    court_cases = CourtCase.valid.without_docket_events.with_html
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      Importers::CourtCase.perform(c)
      bar.increment!
    end
  end

  task :case_html do
    court_cases = CourtCase.without_html
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      c.build_case_html unless c.case_html
      case_search = OscnScraper::Requestor::Case.new({ county: c.county.name, number: c.case_number })
      sleep 1
      request = case_search.fetch_case_by_number
      c.case_html.update({
                           scraped_at: DateTime.current,
                           html: request.body
                         })
      bar.increment!
    end
  end

  # TODO: Delete
  task :update_judge do
    court_cases = CourtCase.all
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      parsed_html = Nokogiri::HTML(c.case_html.html.body)
      data = OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
      logs = Importers::Logger.new(c)
      judge_id = Matchers::Judge.new(data[:judge]).judge_id
      c.update(current_judge_id: judge_id)
      bar.increment!
    end
  end

  task :one_off, [:case_number] do |_t, args|
    case_search = OscnScraper::Requestor::Case.new({county: c.county.name, number: c.case_number})
    c = CourtCase.find_by(case_number: args.case_number)
    puts "Scraping HTML for #{args.case_number}"

    html = case_search.fetch_case_by_number
    c.build_case_html unless c.case_html
    c.case_html.update({
                         html: html.body, scraped_at: DateTime.current
                       })

    Importers::CourtCase.perform(c)
  end
end
