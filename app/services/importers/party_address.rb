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
      address_columns = row.children.css('td')
      return if address_columns.count == 1 # No records found

      return if address_columns[3].text.blank? # Skip if no address information found

      begin
        address_string = address_columns[3].text.split(',')
        address = {
          party_id: party.id,
          record_on: Date.strptime(address_columns[0].text, '%m/%d/%Y'),
          status: address_columns[1].text,
          city: address_string[0],
          state: address_string[1].split[0],
          zip: address_string[1].split[1].squish.to_i,
          address_type: address_columns[2].text
        }
      rescue StandardError
        # TODO: Create log on the Parties table
      end

      ::PartyAddress.find_or_create_by(address)
    end
  end
end
