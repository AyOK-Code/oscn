namespace :tulsa_city do
    desc 'Scrape 90 days inmate list data'
    task inmate_list: [:environment] do
     
      Scrapers::TulsaCity::TulsaInmates.perform
    end
  end