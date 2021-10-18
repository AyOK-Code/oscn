require 'uri'

namespace :scrape do
  desc 'Scrape cases data'
  task :court_cases, [:year, :county] => [:environment] do |_t, args|
    # TODO: Change to import task
    year = args.year.to_i
    county = args.county
    dates = (Date.new(year, 1, 1)..Date.new(year, 12, 31)).to_a
    case_types = CaseType.oscn_id_mapping
    counties = County.pluck(:name, :id).to_h

    dates.each do |date|
      sleep 2
      scraper = OscnScraper::Requestor::Report.new({ county: county, date: date })
      html = scraper.fetch_daily_filings
      data = Nokogiri::HTML(html.body)
      puts "Pulling cases from #{date.strftime('%m/%d/%Y')}"

      data.css('tr a').each do |row|
        uri = URI(row['href'])
        params = CGI.parse(uri.query)
        case_number = row.text
        oscn_id = params['casemasterID'].first.to_i
        county = params['db'].first
        case_type = case_number.split('-').first
        next if case_types[case_type].blank?

        c = ::CourtCase.find_or_initialize_by(oscn_id: oscn_id, county_id: counties[county])
        c.case_type_id = case_types[case_type]
        c.case_number = row.text
        c.filed_on = date
        c.save!
      end
    end
  end
end
