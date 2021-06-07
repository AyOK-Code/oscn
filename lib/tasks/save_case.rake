namespace :save do
  desc 'Scrape cases data'
  task :case do
    cases = Case.valid
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      CaseImporter.new(c).perform
      bar.increment!
    end
  end
end
