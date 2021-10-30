require 'open-uri'

namespace :save do
  desc 'Pull in attorneys from OK Bar site'
  task attorneys: [:environment] do
    states = ['AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']

    states.each do |state|
      puts "Importing data for #{state}"
      Scrapers::Attorney.perform(state)
    end
  end
end
