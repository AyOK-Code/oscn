module Importers
  # Save detailed Party information
  class PartyAddress
    attr_accessor :party
    attr_reader :row

    def initialize(html_row, party_object)
      @row = html_row
      @party = party_object
    end

    def self.perform(row, party)
      new(row, party).perform
    end

    def perform
      address = OscnScraper::Parsers::PartyAddress.perform(row, party)

      ::PartyAddress.find_or_create_by(address)
    end
  end
end
