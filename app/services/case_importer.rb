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
    @docket_event_types = DocketEventType.pluck(:code, :id).to_h
    @logs = Hash.new
  end

  def self.perform(case_object)
    self.new(case_object).perform
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
      events_json = data[:events]
      events_json.each do |event_data|
        save_events(event_data)
      end
      attorneys_json = data[:attorneys]
      attorneys_json.each do |attorney_data|
        save_attorneys(attorney_data)
      end
      docket_events_json = data[:docket_events]
      docket_events_json.each do |docket_event|
        save_docket_event(docket_event)
      end
      save_logs
    end
  end

  private

  attr_accessor :data, :party_types, :case, :parties, :pleas, :verdicts, :skipped, :logs, :docket_event_types

  def save_logs
    if logs.present?
      @case.update(logs: logs)
    else
      @case.update(logs: nil)
    end
  end

  def save_attorneys(attorney_data)
    if attorney_data[:bar_number].present?
      c = Counsel.find_or_initialize_by(bar_number: attorney_data[:bar_number]&.to_i)
    else
      c = Counsel.find_or_initialize_by(name: attorney_data[:name].downcase)
    end

    c.assign_attributes({
                          name: attorney_data[:name].downcase,
                          address: attorney_data[:address],
                          bar_number: attorney_data[:bar_number]&.to_i
                        })
    if c.save
      data = { case_id: @case.id, counsel_id: c.id, party_id: party_id(attorney_data[:represented_parties].squish) }
      CounselParty.find_or_create_by(data)
    else
      create_log('counsel', "#{@case.case_number} resulted in an error when creating the counsel", attorney_data)
    end
  end

  def save_events(event_data)
    e = find_event(event_data)
    e.docket = event_data[:docket]
    e.event_type = event_data[:event_type]
    begin
      e.save!
    rescue StandardError
      create_log('events', "#{@case.case_number} resulted in an error when creating the event", event_data)
    end
  end

  def find_event(event_data)
    Event.find_or_initialize_by({
                                  case_id: @case.id,
                                  event_at: event_data[:date],
                                  party_id: party_id(event_data[:party_name].squish)
                                })
  end

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
    begin
      c.save!
    rescue StandardError
      create_log('counts', "#{@case.case_number} skipped count due to missing party.", count_data)
    end
  end

  def save_docket_event(docket_event_data)
    de = DocketEvent.find_or_initialize_by(case_id: @case.id, event_on: docket_event_data[:date], docket_event_type_id: find_or_create_docket_event_type(docket_event_data[:code]))
    de.assign_attributes({
      description: docket_event_data[:description],
      amount: currency_to_number(docket_event_data[:amount]),
      party_id: party_id(docket_event_data[:party])
      })

      de.save
  end

  def currency_to_number currency
   currency.to_s.gsub(/[$,]/,'').to_f
  end

  def create_log(table, message, data)
    logs["#{table}"] = { message: message, data: data }
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

  def find_or_create_docket_event_type(docket_event_type)
    docket_event_type_id = docket_event_types[docket_event_type]
    return nil if docket_event_type.nil?

    return docket_event_type_id if docket_event_type_id

    new_docket_event_type = DocketEventType.create(code: docket_event_type)
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
      create_log('parties', "#{@case.case_number} resulted in an error when creating the party", party_data)
    end
    create_case_party(@case.id, party.id)
  end

  def create_case_party(case_id, party_id)
    data = {case_id: case_id, party_id: party_id}
    CaseParty.find_or_create_by!(data)
  rescue StandardError
    create_log('case_parties', "#{@case.case_number} resulted in an error when creating case party relationship", data)
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
