module Importers
  # Save detailed Party information
  class PartyData
    attr_accessor :party

    def initialize(oscn_id)
      @party = ::Party.find_by(oscn_id: oscn_id)
    end

    def self.perform(oscn_id)
      new(oscn_id).perform
    end

    # TODO: Move data parsing to the Gem side
    def perform
      html = party.party_html.html
      parsed_html = Nokogiri::HTML(html)
      personal_columns = personal_html(parsed_html)
      aliases_column = aliases_html(parsed_html)

      save_aliases(aliases_column)
      save_personal(parsed_html)
      save_addresses(parsed_html)
    end

    def save_addresses(parsed_html)
      address_row = address_html(parsed_html)
      return if address_row.count < 2

      address_row.each_with_index do |row, index|
        next if index.zero? # Skip header

        PartyAddress.perform(row, party)
      end
    end

    def save_personal(personal_columns)
      string = personal_columns[2]&.text&.split('/')
      return if string.blank?

      party.update(birth_month: month(string), birth_year: year(string))
    end

    def save_aliases(aliases_column)
      aliases_column.each do |row|
        next if row.class != Nokogiri::XML::Text

        PartyAlias.find_or_create_by(party: party, name: row.text.squish)
      end
    end

    def month(string)
      string[0].to_i
    end

    def year(string)
      string[1].to_i
    end

    def personal_html(parsed_html)
      parsed_html.css('.personal tr td')
    end

    def aliases_html(parsed_html)
      parsed_html.css('.partymain tr td')[1].children
    end

    def address_html(parsed_html)
      parsed_html.css('.addresses tr')
    end
  end
end
