namespace :lexus_nexus do
  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import_from_crime_map: [:environment] do
    Importers::CrimeMap.perform
  end

  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import_from_nacok: [:environment] do
    Importers::NacokCrime::Page.perform
  end
end
