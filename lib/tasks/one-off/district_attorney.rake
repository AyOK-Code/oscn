require 'open-uri'

namespace :save do
  desc 'Load District Attorney Data'
  task district_attorney:  [:environment] do
    html = OscnScraper::Requestor::DistrictAttorney.new

    html = html.perform
    parser = OscnScraper::Parsers::DistrictAttorney.new(html)
    parser.perform

    parsed_json = parser.district_attorneys

     district_attorney = Scrapers::DistrictAttorney.new(parsed_json)
     district_attorney.perform
     
     
  end
end
