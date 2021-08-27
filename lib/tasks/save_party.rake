namespace :save do
  desc 'Save party information'
  task parties: [:environment] do
    parties = Party.defendant.without_birthday
    bar = ProgressBar.new(parties.count)

    parties.each do |p|
      bar.increment!
      PartyWorker.perform_async(p.oscn_id)
    end
  end
end
