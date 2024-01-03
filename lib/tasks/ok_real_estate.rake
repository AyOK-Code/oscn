namespace :ok_real_estate do
  desc 'Loop through API to pull in data'
  task import: [:environment] do
    Importers::OkRealEstate::Import.perform
  end
end