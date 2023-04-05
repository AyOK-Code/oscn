module Scrapers
  # Lowest priority for update
  class LowPriority
    attr_accessor :cases

    def initialize(days_ago: 90, limit: low_count)
      @cases = CourtCase.closed.older_than(days_ago.days.ago).limit(limit)
    end

    def self.perform(days_ago: 90)
      new(days_ago: days_ago).perform
    end

    def perform
      puts "Pulling #{cases.count} low priority cases"
      bar = ProgressBar.new(cases.count)

      cases.each do |c|
        county = c.county

        case_number = c.case_number
        court_case = ::CourtCase.find_by!(county_id: county.id, case_number: c.case_number)

        next if court_case.enqueued

        court_case.update(enqueued: true)
        CourtCaseWorker
          .set(queue: :low)
          .perform_async(county.id, case_number, true)
        bar.increment!
      end
    end

    private

    def low_count
      ENV.fetch('LOW_PRIORITY', 10_000).to_i
    end
  end
end
