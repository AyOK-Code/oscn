module Scrapers
  # Updates html for cases that have been on the docket in the past week or cases without html (new cases)
  class HighPriority
    attr_accessor :days_ago

    def initialize(days_ago: 7)
      @days_ago = days_ago
    end

    def self.perform(days_ago: 7)
      new(days_ago: days_ago).perform
    end

    def perform
      cases = fetch_case_list

      bar = ProgressBar.new(cases.count)
      puts "#{cases.count} are high priority for update"

      cases.each do |case_number|
        Importers::CaseHtml.perform(case_number)
        bar.increment!
      end
    end

    def fetch_case_list
      missing_html_cases = CourtCase.without_html.pluck(:case_number)
      recent_cases = Scrapers::RecentCases.perform(days_ago: days_ago)
      (missing_html_cases + recent_cases).flatten
    end
  end
end
