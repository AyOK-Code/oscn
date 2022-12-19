require 'csv'

namespace :import do
  desc 'Reset database and run all tasks'
  task :save  do
    csv = File.read('spec/fixtures/importers/parcels.csv')
    binding.pry
    parcel = Importers::Parcel.new(csv).perform
    #parcel.perform
  end
end

