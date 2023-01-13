namespace :pd do
  desc 'Scape and parse'
  task :booking do
    Importers::Pd::Booking.perform(test_json)
  end

  task :offense do
    Importers::Pd::Offense.perform(test_json)
  end
end
