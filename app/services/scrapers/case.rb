module Scraper
  class Case
    def initialize
      scraper = OscnScraper::Search.new
      date = Date.current
      rescued = 0
    end

    def self.perform
      new.perform
    end

    def new_cases
      # TODO: get cases that were filed in the past 7 days to ensure they are in the database
    end

    def high_priority_cases
      # TODO: Get cases that have been on the docket in past 7 days
    end

    def mid_priority_cases
      # TODO: Get open cases
    end

    def low_priority_cases
      # TODO: Closed cases that have not been scraped in a while
    end

    def perform
      cases.without_html.each_with_index do |c, _i|
        county = c.county.name
        number = c.case_number
        puts "Pulling case: #{number} for #{county}"
        html = scraper.fetch_case_by_number(county, number)
        c.update(html: html, scraped_at: Time.current)
        bar.increment!
      rescue Net::OpenTimeout, Errno::ETIMEDOUT
        rescued += 1
        sleep 10
        next
      end
      ap rescued
    end
  end
end
