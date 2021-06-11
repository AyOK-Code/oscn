namespace :save do
  desc 'Scrape court_cases data'
  task :court_cases do
    court_cases = CourtCase.valid
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      Importers::CourtCase.perform(c)
      bar.increment!
    end
  end

  task :case_html do
    court_cases = CourtCase.all
    bar = ProgressBar.new(court_cases.count)

    court_cases.each do |c|
      c.build_case_html unless c.case_html
      c.case_html.update({
          scraped_at: c.scraped_at,
          html: c.html
        })
      bar.increment!
    end
  end
end
