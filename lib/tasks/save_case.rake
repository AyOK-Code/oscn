namespace :save do
  desc 'Scrape cases data'
  task :court_cases do
    cases = CourtCase.valid
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      CaseImporter.perform(c)
      bar.increment!
    end
  end
end
