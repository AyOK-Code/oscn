namespace :lexus_nexus do
  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import: [:environment] do
    Importers::CrimeMap.perform
  end

  desc 'Import data from historic OKC PD pdfs (same data as crime map)'
  task import_historic: [:environment] do
    Importers::NacokCrime::Page.perform
  end
end

