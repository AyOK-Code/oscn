require 'open-uri'

namespace :copy do
  desc 'copy data from doc_profiles'
  task doc_profiles: :environment do
    profiles = Doc::Profile.all
    profiles.each  do |profile|
        roster = ::Roster.new()
        roster.sex = profile.sex
        roster.race = profile.race
        roster.birth_day = profile.birth_date.day
        roster.birth_month = profile.birth_date.month
        roster.birth_year = profile.birth_date.year
        roster.first_name = profile.first_name
        roster.last_name = profile.last_name
        roster.middle_name = profile.middle_name
        roster.save!
        puts "Saving roster record: " +roster.first_name + " " +roster.middle_name + " "+ roster.last_name 
        
        


    end
  end
end
