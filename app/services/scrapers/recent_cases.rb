module Scrapers
  # Returns cases on the docket for the past X days
  class RecentCases
    attr_reader :days_ago, :case_types, :case_changes
    attr_accessor :recent_cases

    def initialize(days_ago: 7)
      @case_changes = OscnScraper::Parsers::CaseChanges
      @case_types = CaseType.active
      @recent_cases = []
      @days_ago = days_ago
    end

    def self.perform(days_ago: 7)
      new(days_ago: days_ago).perform
    end

    def perform
      date_range.each do |date|
        puts "Pulling case changes for #{date.to_date}"
        fetch_docket_for_date(date)
      end
      recent_cases.flatten
    end

    def fetch_docket_for_date(date)
      case_types.each do |case_type_oscn_id|
        # TODO: Pull out county to configuration
        scraper = OscnScraper::Requestor::Report.new({county: 'Oklahoma', case_type_id: case_type_oscn_id, date: date})
        request = scraper.events_scheduled
        data = case_changes.new(Nokogiri::HTML.parse(request.body)).parse
        next if data.empty?

        recent_cases << data
      end
      recent_cases
    end

    def date_range
      (days_ago.days.ago.to_date..Date.current.to_date).to_a
    end
  end
end
