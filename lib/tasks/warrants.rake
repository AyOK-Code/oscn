namespace :save do
  desc 'Scrape cases data'
  task :warrants do
    warrant_events = DocketEvent.for_code('WAI$')
    bar = ProgressBar.new(warrant_events.count)

    warrant_events.each do |warrant_event|
      # TODO: What to do with judges who do not exist (create?)
      bar.increment!
      Importers::DocketEvents::Warrant.perform(warrant_event)
    end
  end
end
