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

    # TODO: Refactor method
    def perform
      begin
        data = OscnScraper::Requestor::Party.fetch_party('oklahoma', party.oscn_id)
        parsed_html = Nokogiri::HTML(data.body)
      rescue StandardError
        puts 'Error occurred'
        return
      end
      personal_columns = personal_html(parsed_html)

      string = personal_columns[2]&.text&.split('/')
      return if string.blank?

      month = string[0]
      year = string[1]
      party.update(birth_month: month.to_i, birth_year: year.to_i)

      address_row = address_html(parsed_html)
      return if address_row.count < 2

      address_row.each_with_index do |row, index|
        next if index.zero? # Skip header

        PartyAddress.perform(row, party)
      end
    end

    def personal_html(parsed_html)
      parsed_html.css('.personal tr td')
    end

    def address_html(parsed_html)
      parsed_html.css('.addresses tr')
    end
  end
end
