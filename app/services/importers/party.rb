module Importers
  # Saves Party information to the database
  class Party
    attr_reader :parties_json, :party_types
    attr_accessor :court_case, :logs

    def initialize(parties_json, court_case, logs)
      @parties_json = parties_json
      @court_case = court_case
      @party_types = ::PartyType.pluck(:name, :id).to_h
      @logs = logs
    end

    def self.perform(parties_json, court_case, logs)
      new(parties_json, court_case, logs).perform
    end

    def perform
      parties_json.each do |party_data|
        if party_data[:link].present?
          save_parties(party_data)
        else
          save_parties_text(party_data)
        end
      end
    end

    private

    def save_parties(party_data)
      oscn_id = parse_id(party_data[:link])
      party = ::Party.find_by(oscn_id: oscn_id)

      if party
        party.update(full_name: party_data[:name])
        save_existing_party_to_case(party)
        Matchers::PartyNameSplitter.new(party).perform
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

    def save_existing_party_to_case(party)
      create_case_party(court_case.id, party.id)
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
      return if party.nil?

      Matchers::PartyNameSplitter.new(party).perform
      create_case_party(court_case.id, party.id)
    end

    def create_and_save_party_to_case_text(party_data)
      full_name = party_data[:name].squish
      begin
        party_type_id = find_or_create_party_type(party_data[:party_type].downcase)
      rescue NoMethodError
        logs.create_log('parties', "#{court_case.case_number}: error when creating the party", party_data)
      end

      return if text_only_party_exists?(full_name, party_type_id)

      begin
        party = ::Party.create!(
          full_name: full_name,
          party_type_id: party_type_id
        )
      rescue StandardError
        logs.create_log('parties', "#{court_case.case_number}: error when creating the party", party_data)
      end
      return if party.nil?

      Matchers::PartyNameSplitter.new(party).perform
      create_case_party(court_case.id, party.id)
    end

    def text_only_party_exists?(full_name, party_type_id)
      ::Party.joins(:case_parties).where(
        full_name: full_name,
        party_type_id: party_type_id,
        case_parties: { court_case_id: court_case.id }
      ).present?
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
