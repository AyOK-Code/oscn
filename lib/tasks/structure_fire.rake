require 'open-uri'

namespace :save do
  desc 'Pull structure fire pdfs'
  task structure_fire: :environment do
    year = 2023
    start_date = Date.parse('07/10/2023')
    end_date = Date.strptime('01/04/2024', '%m/%d/%Y')
    dates = (start_date..end_date).to_a
    dates[0].strftime('%m/%d/%Y')
    months = [{ month: 'july', days: 31 }, { month: 'august', days: 31 }, { month: 'september', days: 30 },
              { month: 'october', days: 31 }, { month: 'november', days: 30 }, { month: 'december', days: 31 }]
    months.each do |month|
      1.upto(month[:days]) do |i|
        day_int = format('%02d', i)
        month_int = format('%02d', Date::MONTHNAMES.index(month[:month].capitalize))
        jsons = Scrapers::StructureFireExtraction.new(year, month[:month], "#{month_int}/#{day_int}/2023").perform
        binding.pry
        #fire_link = Importers::StructureFireLink.new(jsons).perform
        fire_struct = Importers::StructureFire.perform
       #binding.pry
      end
    end
  end
end
