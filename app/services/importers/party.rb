module Importers
  class Party
    attr_reader :parties_json, :party_type, :parties
    attr_accessor :court_case, :logs

    def initialize(parties_json, court_case, logs)
      @parties_json = parties_json
      @court_case = court_case
      @parties = ::Party.pluck(:oscn_id, :id).to_h
      @party_types = ::PartyType.pluck(:name, :id).to_h
      @logs = logs
    end

    def self.perform(parties_json, court_case, logs)
      new(parties_json, court_case, logs).perform
    end

    def perform
      parties_json.each do |party_data|
        save_parties(party_data)
      end
    end

    def save_parties(party_data)
      oscn_id = parse_id(party_data[:link])
      if parties[oscn_id]
        save_existing_party_to_case(oscn_id)
      else
        create_and_save_party_to_case(oscn_id, party_data)
      end
    end

    def parse_id(link)
      uri = URI(link)
      params = CGI.parse(uri.query)
      params['id'].first.to_i
    end

    def save_existing_party_to_case(oscn_id)
      party_id = parties[oscn_id]
      create_case_party(court_case.id, party_id)
    end

    def find_or_create_party_type(party_type)
      party_type_id = party_types[party_type]
      return party_type_id if party_type_id

      new_party_type = PartyType.create(name: party_type)
      new_party_type.id
    end

    def create_and_save_party_to_case(oscn_id, party_data)
      begin
        party = Party.create(
          oscn_id: oscn_id,
          full_name: party_data[:name],
          party_type_id: find_or_create_party_type(party_data[:party_type].downcase)
        )
      rescue StandardError
        create_log('parties', "#{court_case.case_number} resulted in an error when creating the party", party_data)
      end
      create_case_party(court_case.id, party.id)
    end

    def create_case_party(court_case_id, party_id)
      data = { court_case_id: court_case_id, party_id: party_id }
      CaseParty.find_or_create_by!(data)
    rescue StandardError
      create_log('case_parties', "#{court_case.case_number} resulted in an error when creating case party relationship",
                 data)
    end
  end
end
