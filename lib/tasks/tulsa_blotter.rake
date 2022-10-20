namespace :tulsa_blotter do
  desc 'Scrape cases data'
  task daily_import: [:environment] do
    Importers::TulsaBlotter::DailyImport.perform
  end
end
