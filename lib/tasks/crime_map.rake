namespace :crime_map do
  desc 'Import data from the Lexis Nexis crime map'
  task import: [:environment] do
    Scrapers::NacokCrime::Page.perform
  end
end

