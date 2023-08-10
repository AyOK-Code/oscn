module Importers
  # Saves the Html of a court case to the database
  class PartyHtml
    attr_accessor :party, :oscn_id

    def initialize(oscn_id)
      @party = ::Party.find_by!(oscn_id: oscn_id)
      @oscn_id = oscn_id
    end

    def self.perform(oscn_id)
      new(oscn_id).perform
    end

    def perform
      county_name = @party.court_cases.first.county.name
      data = OscnScraper::Requestor::Party.fetch_party(county_name, oscn_id)
  rescue StandardError => e
      Raygun.track_exception(e, custom_data: { error_type: 'Request Error' })
    else
      save_html(party, data)
    end

    private

    def save_html(party, html)
      party.build_party_html unless party.party_html
      party.party_html.update({
                                html: html, scraped_at: DateTime.current
                              })
    end
  end
end
