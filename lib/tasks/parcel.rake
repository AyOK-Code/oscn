require 'csv'

namespace :import do
  desc 'Reset database and run all tasks'
  task save:  [:environment] do
    csv = File.read('spec/fixtures/importers/parcels.csv')
    
    parcel = Importers::Parcel.new(csv).perform
    
  end
end

