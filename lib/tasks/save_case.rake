namespace :save do
  # TODO: Delete
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

  task update_year: [:environment] do
    cases = CourtCase.where(filed_on: Date.new(2020,7,1)..Date.new(2021,7,1)).where("case_number LIKE 'C%'")
    bar = ProgressBar.new(cases.count)
    cases.each do |c|
      bar.increment!
      CourtCaseWorker.perform_async(c.case_number)
    end
  end
end
