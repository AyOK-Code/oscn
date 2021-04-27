require 'uri'

namespace :scrape do
  desc "Scrape cases data"
  task :cases, [:year] do |_t, args|
    # TODO: Change to import task
    # TODO: Move to gem configuration
    CASE_TYPES = ['CF','CM','TR','TRI','AM','CPC','DTR']

    year = args.year.to_i
    scraper = OscnScraper::BaseScraper.new
    dates = (Date.new(year, 1, 1)..Date.new(year, 12, 31)).to_a
    case_types = CaseType.where(abbreviation: CASE_TYPES).pluck(:abbreviation, :id).to_h
    counties = County.pluck(:name, :id).to_h
    bar = ProgressBar.new(dates.count)


    dates.each do |date|
      html = scraper.fetch_daily_filings(date)
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
          c = Case.find_or_initialize_by(oscn_id: oscn_id)
          c.county_id = counties[county]
          c.case_type_id = case_types[case_type]
          c.case_number = row.text
          c.filed_on = date
          c.save!
        end
      end
      bar.increment!
    end
  end
end
