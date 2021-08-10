module Importers
  # Saves the docket event to the database
  class DocketEvent
    attr_accessor :logs, :court_case, :party_matcher
    attr_reader :docket_event_json, :docket_event_types

    def initialize(docket_event_json, court_case, docket_event_types, logs)
      @docket_event_json = docket_event_json
      @court_case = court_case
      @logs = logs
      @docket_event_types = docket_event_types || DocketEventType.pluck(:code, :id).to_h
      @party_matcher = Matchers::Party.new(court_case)
    end

    def self.perform(docket_event_json, court_case, docket_event_types, logs)
      new(docket_event_json, court_case, docket_event_types, logs).perform
    end

    def perform
      expected_events = docket_event_json.count
      docket_event_json.each_with_index do |docket_event, index|
        save_docket_event(docket_event, index)
      end
      docket_events = @court_case.docket_events.count

      if docket_events != expected_events
        logs.create_log('docket_events', 'DocketEventCountError',
                        'The number of docket events created for the case does not match the expected number.')
      end
    end

    def save_docket_event(docket_event_data, index)
      event_type_id = find_or_create_docket_event_type(docket_event_data[:code])
      party_id = party_matcher.party_id_from_name(docket_event_data[:party])

      docket_event = ::DocketEvent.find_or_initialize_by(
        row_index: index,
        court_case_id: court_case.id
      )

      docket_event.assign_attributes(
        event_on: docket_event_data[:date],
        docket_event_type_id: event_type_id,
        count: docket_event_data[:count].blank? ? nil : docket_event_data[:count],
        party_id: party_id,
        description: docket_event_data[:description],
        amount: currency_to_number(docket_event_data[:amount])
      )
      docket_event.save!

      if docket_event.docket_event_type.code == 'ACCOUNT'
        Importers::DocketEvents::Fee.perform(docket_event, docket_event_data, court_case.case_number)
      end
    end

    def find_or_create_docket_event_type(docket_event_type)
      docket_event_type_id = docket_event_types[docket_event_type]
      return nil if docket_event_type.nil?

      return docket_event_type_id if docket_event_type_id

      new_docket_event_type = DocketEventType.find_or_initialize_by(code: docket_event_type)
      new_docket_event_type.save
      new_docket_event_type.id
    end

    def currency_to_number(currency)
      currency.to_s.gsub(/[$,]/, '').to_f
    end
  end
end