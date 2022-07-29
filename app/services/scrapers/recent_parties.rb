module Scrapers
  # Returns parties on the docket for the past X days
  class RecentParties
    attr_reader :days_ago, :party_types, :party_changes, :court_parties, :county, :days_forward
    attr_accessor :recent_parties

    def initialize(county, days_ago, days_forward)
      @party_changes = OscnScraper::Parsers::PartyChanges
      @county = county
      @court_parties = Party.pluck(:party_number, :oscn_id).to_h
      @party_types = PartyType.active
      @recent_parties = []
      @days_ago = days_ago
      @days_forward = days_forward
    end

    def self.perform(county, days_ago: 7, days_forward: 7)
      new(county, days_ago, days_forward).perform
    end

    def perform
      date_range.each do |date|
        puts "Pulling party changes for #{date.to_date}"
        fetch_docket_for_date(date)
      end
      recent_parties.flatten
    end

    def fetch_docket_for_date(date)
      party_types.each do |party_type_oscn_id|
        party_numbers = scrape_recent_parties(date, party_type_oscn_id)
        recent_parties << party_numbers
      end
      recent_parties
    end

    def scrape_recent_parties(date, party_type_oscn_id)
      data = fetch_data(county, date, party_type_oscn_id)

      data.each do |link|
        Importers::NewParty.new(link).perform if court_parties[link.text].nil?
      end
      return if data.empty?

      data.map(&:text)
    end

    def fetch_data(county, date, party_type_oscn_id)
      scraper = OscnScraper::Requestor::Report.new({
                                                     county: county,
                                                     party_type_id: party_type_oscn_id,
                                                     date: date
                                                   })
      request = scraper.events_scheduled
      party_changes.new(Nokogiri::HTML.parse(request.body)).parse
    end

    def date_range
      (days_ago.days.ago.to_date..days_forward.days.from_now.to_date).to_a
    end
  end
end
