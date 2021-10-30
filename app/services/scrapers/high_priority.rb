module Scrapers
  # Updates html for cases that have been on the docket in the past week or cases without html (new cases)
  class HighPriority
    attr_accessor :days_ago, :county

    def initialize(county, days_ago: 7)
      @days_ago = days_ago
      @county = county
    end

    def self.perform(county, days_ago: 7)
      new(county, days_ago: days_ago).perform
    end

    def perform
      cases = fetch_case_list

      bar = ProgressBar.new(cases.count)
      puts "#{cases.count} are high priority for update"

      cases.each do |case_number|
        CourtCaseWorker.perform_async(county, case_number)
        bar.increment!
      end
    end

    def fetch_case_list
      missing_html_cases = CourtCase.for_county_name(county).without_html.pluck(:case_number)
      recent_cases = Scrapers::RecentCases.perform(county, days_ago: days_ago)
      (missing_html_cases + recent_cases).flatten
    end
  end
end
