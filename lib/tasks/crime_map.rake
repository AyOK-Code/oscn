namespace :crime_map do
  desc 'Import data from the Lexis Nexis crime map'
  task import: [:environment] do
    Importers::CrimeMap.perform
  end
end

