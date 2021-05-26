require 'uri'

# Takes the data from the OscnScraper and imports it into the database
class CaseImporter
  def initialize(case_object)
    @case = case_object
    @parsed_html = Nokogiri::HTML(@case.html)
    @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
    @parties = Party.pluck(:oscn_id, :id).to_h
    @party_types = PartyType.pluck(:name, :id).to_h
    @pleas = Plea.pluck(:name, :id).to_h
    @verdicts = Verdict.pluck(:name, :id).to_h
  end

  def perform
    ActiveRecord::Base.transaction do
      parties_json = data[:parties]
      parties_json.each do |party_data|
        save_parties(party_data)
      end
      counts_json = data[:counts]
      counts_json.each do |count_data|
        save_counts(count_data)
      end
    end
  end

  private

  attr_accessor :data, :party_types, :case, :parties, :pleas, :verdicts

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

  def save_counts(count_data)
    c = find_count(count_data)
    c.assign_attributes({
                          filed_statute_violation: count_data[:filed_statute_violation],
                          disposition: count_data[:disposition],
                          disposition_on: count_data[:disposition_on],
                          disposed_statute_violation: count_data[:disposed_statute_violation],
                          plea_id: find_or_create_plea(count_data[:plea]&.downcase),
                          verdict_id: find_or_create_verdict(count_data[:verdict]&.downcase)
                        })
    c.save!
  end

  def find_count(count_data)
    Count.find_or_initialize_by(
      case_id: @case.id,
      party_id: party_id(count_data[:party_name]),
      offense_on: count_data[:offense_on],
      as_filed: count_data[:as_filed]
    )
  end

  def party_id(party_name)
    parties = @case.parties.pluck(:full_name, :id).map { |a| [a[0].squish, a[1]] }.to_h
    parties[party_name]
  end

  def find_or_create_plea(plea)
    plea_id = pleas[plea]
    return nil if plea.nil?

    return plea_id if plea_id

    new_plea = Plea.create(name: plea)
    new_plea.id
  end

  def find_or_create_verdict(verdict)
    verdict_id = verdicts[verdict]
    return verdict_id if verdict_id

    new_verdict = Verdict.create(name: verdict)
    new_verdict.id
  end

  def create_and_save_party_to_case(oscn_id, party_data)
    begin
      party = Party.create(
        oscn_id: oscn_id,
        full_name: party_data[:name],
        party_type_id: find_or_create_party_type(party_data[:party_type].downcase)
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

  def find_or_create_party_type(party_type)
    party_type_id = party_types[party_type]
    return party_type_id if party_type_id

    new_party_type = PartyType.create(name: party_type)
    new_party_type.id
  end
end
