namespace :save do
  desc 'Scrape cases data'
  task :case do
    cases = Case.valid
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      CaseImporter.perform(c)
      bar.increment!
    end
  end
end
