require 'open-uri'

namespace :copy do
  desc 'Pull judges for a county'
  task doc_profiles: :environment do
    profiles = Doc::Profile.all.count
    profiles.each |profile| do
        roster = ::Roster.new()
        roster.sex = profile.sex
        roster.race = profile.race
        roster.first_name = profile.first_name
        roster.last_name = profile.last_name
        roster.middle_name = profile.middle_name


    end
  end
end
