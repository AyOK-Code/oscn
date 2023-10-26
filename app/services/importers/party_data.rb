module Importers
  # Save detailed Party information
  class PartyData
    attr_accessor :party

    def initialize(oscn_id)
      @party = ::Party.find_by!(oscn_id: oscn_id)
    end

    def self.perform(oscn_id)
      new(oscn_id).perform
    end

    # TODO: Move data parsing to the Gem side
    def perform
      html = party.party_html.html
      parsed_html = Nokogiri::HTML(html)
      data = OscnScraper::Parsers::PartyData.perform(parsed_html)

      personal_columns = data[:personal_columns]
      aliases_column = data[:aliases_column]
      begin
        save_aliases(aliases_column)
        save_personal(personal_columns)
        save_addresses(data)
      rescue StandardError => e
        Raygun.track_exception(e, custom_data: { error_type: 'Data Error', data_content: parsed_html })
      end
    end

    def save_addresses(data)
      address_row = data[:address_row]
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
  end
end
