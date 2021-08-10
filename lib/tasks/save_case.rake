namespace :save do
  desc 'Scrape court_cases data'
  task court_cases: [:environment] do
    court_cases = CourtCase.valid.with_html.last_scraped(19.days.ago)
    bar = ProgressBar.new(court_cases.count)
    docket_event_types = DocketEventType.pluck(:code, :id).to_h
    pleas = Plea.pluck(:name, :id).to_h
    verdicts = Verdict.pluck(:name, :id).to_h

    court_cases.each do |c|
      Importers::CourtCase.perform(c, docket_event_types, pleas, verdicts)
      bar.increment!
    end
  end

  task :case_html do
    court_cases = CourtCase.valid.where(case_number: 'CF-2018-2360')
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

  task :purge_errors do
    court_cases = CourtCase.with_html
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      data = Nokogiri::HTML.parse(c.case_html.html)
      errors = data.css('.errorMessage')
      if errors.count > 0
        c.case_html.destroy
      end
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
