module Importers
  # Save detailed Party information
  class Parties
    attr_accessor :results, :parties

    def initialize
      @parties = ::Party.joins(case_parties: :court_case).where(court_cases: { filed_on: Date.new(2020,7,1)..Date.new(2021,7,1) }).without_birthday.defendant
    end

    def self.perform
      new.perform
    end

    def fetch_data; end

    # TODO: Refactor method
    def perform
      bar = ProgressBar.new(parties.count)
      parties.each do |party|
        bar.increment!
        begin
          data = OscnScraper::Requestor::Party.fetch_party('oklahoma', party.oscn_id)
          parsed_html = Nokogiri::HTML(data.body)
        rescue StandardError
          next
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
