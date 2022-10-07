module Importers
  # Saves Party information to the database
  class Party
    attr_reader :parties_json, :parties, :party_types
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
        if party_data[:link].nil?

          save_parties_text(party_data)
        else
          #  binding.pry
          save_parties(party_data)
        end
      end
    end

    private

    def save_parties(party_data)
      oscn_id = parse_id(party_data[:link])

      if parties[oscn_id]
        update_party(parties[oscn_id], party_data)
        save_existing_party_to_case(oscn_id)
      else
        create_and_save_party_to_case(oscn_id, party_data)
      end
    end

    def save_parties_text(party_data)
      create_and_save_party_to_case_text(party_data)
    end

    def parse_id(link)
      uri = URI(link)
      params = CGI.parse(uri.query)
      params['id'].first.to_i
    end

    def update_party(party_id, party_data)
      party = ::Party.find(party_id)
      party.update(
        full_name: party_data[:name]
      )
    end

    def save_existing_party_to_case(oscn_id)
      party_id = parties[oscn_id]
      create_case_party(court_case.id, party_id)
    end

    def find_or_create_party_type(party_type)
      party_type_id = party_types[party_type]
      return party_type_id if party_type_id

      new_party_type = PartyType.create(name: party_type)
      party_types[party_type] = new_party_type.id
      new_party_type.id
    end

    def create_and_save_party_to_case(oscn_id, party_data)
      begin
        party = ::Party.create!(
          oscn_id: oscn_id,
          full_name: party_data[:name].squish,
          party_type_id: find_or_create_party_type(party_data[:party_type].downcase)
        )
      rescue StandardError
        logs.create_log('parties', "#{court_case.case_number}: error when creating the party", party_data)
      end
      # binding.pry
      return if party.nil?

      create_case_party(court_case.id, party.id)
    end

    def create_and_save_party_to_case_text(party_data)
      begin
        party = ::Party.create!(
          full_name: party_data[:name].squish,
          party_type_id: find_or_create_party_type(party_data[:party_type].downcase)
        )
      rescue StandardError
        logs.create_log('parties', "#{court_case.case_number}: error when creating the party", party_data)
      end
      return if party.nil?

      create_case_party(court_case.id, party.id)
    end

    def create_case_party(court_case_id, party_id)
      data = { court_case_id: court_case_id, party_id: party_id }
      CaseParty.find_or_create_by!(data)
    rescue StandardError
      logs.create_log('case_parties', "#{court_case.case_number}: error when creating case party relationship",
                      data)
    end
  end
end
