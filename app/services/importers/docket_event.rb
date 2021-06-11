module Importers
  # Saves the docket event to the database
  class DocketEvent
    attr_accessor :logs, :court_case, :party_matcher
    attr_reader :docket_event_json, :docket_event_types

    def initialize(docket_event_json, court_case, logs)
      @docket_event_json = docket_event_json
      @court_case = court_case
      @logs = logs
      @docket_event_types = DocketEventType.pluck(:code, :id).to_h
      @party_matcher = PartyMatcher.new(court_case)
    end

    def self.perform(docket_event_json, court_case, logs)
      new(docket_event_json, court_case, logs).perform
    end

    def perform
      docket_event_json.each do |docket_event|
        save_docket_event(docket_event)
      end
    end

    def save_docket_event(docket_event_data)
      event_type = find_or_create_docket_event_type(docket_event_data[:code])
      docket_event = ::DocketEvent.find_or_initialize_by(
        court_case_id: court_case.id,
        event_on: docket_event_data[:date],
        docket_event_type_id: event_type)

      party_id = party_matcher.party_id_from_name(docket_event_data[:party])
      docket_event.assign_attributes({
                             description: docket_event_data[:description],
                             amount: currency_to_number(docket_event_data[:amount]),
                             party_id: party_id
                           })
      docket_event.save
    end

    def find_or_create_docket_event_type(docket_event_type)
      docket_event_type_id = docket_event_types[docket_event_type]
      return nil if docket_event_type.nil?

      return docket_event_type_id if docket_event_type_id

      new_docket_event_type = DocketEventType.create(code: docket_event_type)
    end

    def currency_to_number(currency)
      currency.to_s.gsub(/[$,]/, '').to_f
    end
  end
end
