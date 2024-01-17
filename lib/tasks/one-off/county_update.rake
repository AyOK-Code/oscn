require 'open-uri'

namespace :update do
  desc 'Update counties to have oklahoma county code'
  task counties: [:environment] do
    counties = County.order(name: :asc)

    counties.each_with_index do |county, i|
      county.update(ok_code: i + 1)
    end
  end
end
