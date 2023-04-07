require 'uri'

namespace :scrape do
  desc 'Scrape cases into database for a given county and'
  task :court_cases, [:year, :county, :months] => [:environment] do |_t, args|
    args.with_defaults(:months => 12)
    year = args.year.to_i
    months = args.months.to_i
    county = args.county
    dates = (Date.new(year, 1, 1)..Date.new(year, months, 31)).to_a
    case_types = CaseType.oscn_id_mapping
    counties = County.pluck(:name, :id).to_h
    bar = ProgressBar.new(dates.count)

    dates.each_with_index do |date, i|
      bar.increment!
      
      DailyFilingWorker
        .set(queue: :high)
        .perform_async(county, date)
    end
  end
end
