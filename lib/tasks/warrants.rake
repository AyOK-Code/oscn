namespace :save do
  desc 'Scrape cases data'
  task :warrants do
    warrant_events = DocketEvent.for_code('WAI$')
    bar = ProgressBar.new(warrant_events.count)
    judges = Judge.pluck(:name)
    matcher = FuzzyMatch.new(judges)
    matches = {matched: 0, not_matched: 0}

    warrant_events.each do |warrant_event|
      # TODO: What to do with judges who do not exist
      # TODO: Log cases where the warrent event is not parsible
      bar.increment!
      ::Importers::DocketEvents::Warrant.perform(warrant_event)
    end
    ap matches
  end
end
