module Importers
  # Save detailed Party information
  class Parties
    attr_accessor :results, :parties

    def initialize
      @parties = ::Party.without_birthday
    end

    def self.perform
      new.perform
    end

    def fetch_data; end

    # TODO: Refactor class
    def perform
      bar = ProgressBar.new(parties.count)
      parties.each do |party|
        bar.increment!
        begin
          data = OscnScraper::Importers::Party.fetch_party('Oklahoma', party.oscn_id)
          parsed_html = Nokogiri::HTML(data.body)
        rescue StandardError
          next
          # TODO: Log error to parties log
        end
        personal_columns = personal_html(parsed_html)

        string = personal_columns[2]&.text&.split('/')
        next if string.blank?

        month = string[0]
        year = string[1]
        party.update(birth_month: month.to_i, birth_year: year.to_i)

        address_row = address_html(parsed_html)
        next if address_row.count < 2

        address_row.each_with_index do |row, index|
          next if index.zero? # Skip header

          PartyAddress.perform(row, party)
        end
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
