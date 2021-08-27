require 'uri'

namespace :scrape do
  desc "Scrape cases data"
  task :court_cases, [:year] => [:environment] do |_t, args|
    # TODO: Change to import task
    year = args.year.to_i
    dates = (Date.new(year, 1, 1)..Date.new(year, 12, 31)).to_a
    case_types = CaseType.oscn_id_mapping
    counties = County.pluck(:name, :id).to_h
    bar = ProgressBar.new(dates.count)

    dates.each do |date|
      scraper = OscnScraper::Requestor::Report.new({county: 'Oklahoma', date: date})
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
        if case_types[case_type].blank?
          next
        else
          c = CourtCase.find_or_initialize_by(oscn_id: oscn_id)
          c.county_id = counties[county]
          c.case_type_id = case_types[case_type]
          c.case_number = row.text
          c.filed_on = date
          c.save!
        end
      end
    end
  end
end
