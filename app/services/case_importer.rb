require 'uri'

# Takes the data from the OscnScraper and imports it into the database
class CaseImporter
  def initialize(case_object)
    @case = case_object
    @parsed_html = Nokogiri::HTML(@case.html)
    @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
    @parties = Party.pluck(:oscn_id, :id).to_h
    @party_types = PartyType.pluck(:name, :id).to_h
  end

  def perform
    ActiveRecord::Base.transaction do
      parties_json = data[:parties]
      parties_json.each do |party_data|
        save_parties(party_data)
      end
    end
  end

  private

  attr_accessor :data, :party_types, :case, :parties

  def save_parties(party_data)
    oscn_id = parse_id(party_data[:link])
    if parties[oscn_id]
      save_existing_party_to_case(oscn_id)
    else
      create_and_save_party_to_case(oscn_id, party_data)
    end
  end

  def save_existing_party_to_case(oscn_id)
    party_id = parties[oscn_id]
    create_case_party(@case.id, party_id)
  end

  def create_and_save_party_to_case(oscn_id, party_data)
    begin
      party = Party.create!(
        oscn_id: oscn_id,
        full_name: party_data[:name],
        party_type_id: party_type_id(party_data)
      )
    rescue StandardError
      puts "Case: #{@case.case_number} resulted in an error when creating the party"
    end
    create_case_party(@case.id, party.id)
  end

  def create_case_party(case_id, party_id)
    CaseParty.find_or_create_by!(case_id: case_id, party_id: party_id)
  rescue StandardError
    puts "Case: #{@case.case_number} resulted in an error when creating case party relationship"
  end

  def parse_id(link)
    uri = URI(link)
    params = CGI.parse(uri.query)
    params['id'].first.to_i
  end

  def party_type_id(party)
    party_types[party[:party_type].downcase]
  end
end
