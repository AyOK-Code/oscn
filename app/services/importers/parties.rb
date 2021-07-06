module Importers
  class Parties
    def self.perform
      new.perform
    end

    # TODO: Refactor class
    def perform
      results = { multiple_rows: [], skipped: 0, failed: 0 }
      parties = ::Party.without_birthday.first(25_000)
      bar = ProgressBar.new(parties.count)
      parties.each do |party|
        bar.increment!
        begin
          data = OscnScraper::Party.fetch_party('Oklahoma', party.oscn_id)
        rescue StandardError
          results[:failed] += 0
          next
        end
        parsed_html = Nokogiri::HTML(data.body)
        personal_columns = parsed_html.css('.personal tr td')

        string = personal_columns[2]&.text&.split('/')

        results[:multiple_rows] << party.oscn_id if personal_columns.count > 5

        if string.blank?
          results[:skipped] += 1
          next
        end

        month = string[0]
        year = string[1]
        party.update(birth_month: month.to_i, birth_year: year.to_i)

        address_row = parsed_html.css('.addresses tr')
        next if address_row.count < 2

        address_row.each_with_index do |row, index|
          next if index.zero?
          address_columns = row.children.css('td')
          next if address_columns.count == 1 # No records found
          next if address_columns[3].text.blank? # Skip if no address information found

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
            next
          end

          PartyAddress.find_or_create_by(address)
        end

        sleep 4
      end
    end
  end
end
