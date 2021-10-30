namespace :save do
  # TODO: Delete
  task :purge_errors do
    court_cases = CourtCase.with_html
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      data = Nokogiri::HTML.parse(c.case_html.html)
      errors = data.css('.errorMessage')

      c.case_html.destroy if errors.count.positive?
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
      judge_id = Matchers::Judge.new(c.county_id, data[:judge]).judge_id
      c.update(current_judge_id: judge_id)
      bar.increment!
    end
  end
end
