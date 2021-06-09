require 'open-uri'

namespace :save do
  desc 'Pull judges for a county'
  task :attorneys do
    puts "Pulling in all attorneys"
    states = ['AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']

    states.each do |state|
      puts "Importing data for #{state}"
      AttorneyImporter.perform(state)
    end
  end
end
