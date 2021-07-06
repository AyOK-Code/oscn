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
      @party_matcher = Matchers::Party.new(court_case)
    end

    def self.perform(docket_event_json, court_case, logs)
      new(docket_event_json, court_case, logs).perform
    end

    def perform
      expected_events = docket_event_json.count
      docket_event_json.each do |docket_event|
        save_docket_event(docket_event)
      end
      docket_events = @court_case.docket_events.count
      if docket_events != expected_events
        logs.create_log('docket_events', 'DocketEventCountError', 'The number of docket events created for the case does not match the expected number.')
      end
    end

    def save_docket_event(docket_event_data)
      event_type_id = find_or_create_docket_event_type(docket_event_data[:code])
      party_id = party_matcher.party_id_from_name(docket_event_data[:party])

      docket_event = ::DocketEvent.find_or_initialize_by(
        court_case_id: court_case.id,
        event_on: docket_event_data[:date],
        docket_event_type_id: event_type_id,
        count: docket_event_data[:count].blank? ? nil : docket_event_data[:count],
        party_id: party_id,
        description: docket_event_data[:description],
        amount: currency_to_number(docket_event_data[:amount]),
      )
      if docket_event.docket_event_type.code == 'ACCOUNT'
        docket_event.assign_attributes({
          adjustment: calculate_adjustment(docket_event_data),
          payment: calculate_payment(docket_event_data)
        })
      end
      docket_event.save!
    end

    def find_or_create_docket_event_type(docket_event_type)
      docket_event_type_id = docket_event_types[docket_event_type]
      return nil if docket_event_type.nil?

      return docket_event_type_id if docket_event_type_id
      det = DocketEventType.find_or_initialize_by(code: docket_event_type)
      det.save
      det.id
    end

    def currency_to_number(currency)
      currency.to_s.gsub(/[$,]/, '').to_f
    end

    def calculate_payment(docket_event_data)
      regex = /PAID:\s*?\$\s*?((\d|,)+\.\d+)/
      payment = regex.match(docket_event_data[:description])
      return if payment.nil?

      payment = payment[1]&.to_f
      payment
    end

    def calculate_adjustment(docket_event_data)
      return if docket_event_data[:description].exclude? ('ADJUSTING ENTRY')
      data = docket_event_data[:description].split(court_case.case_number)
      adjustment = 0.to_f
      money_regex = /(-|\$)?(\d|,)+\.\d{2}/

      data.each do |string|
        money = money_regex.match(string)
        next if money.nil?

        m = Monetize.parse(money[0])
        adjustment += m.dollars&.to_f
      end
      adjustment
    end
  end
end
