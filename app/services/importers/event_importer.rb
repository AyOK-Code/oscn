class EventImporter
  attr_accessor :events_json, :court_case

  def initialize(events_json, court_case)
    @court_case = court_case
    @events_json = events_json
  end

  def self.perform(events_json)
    new(events_json).perform
  end

  def perform
    events_json.each do |event_data|
      save_events(event_data)
    end
  end

  def save_events(event_data)
    e = find_event(event_data)
    e.docket = event_data[:docket]
    e.event_type = event_data[:event_type]
    begin
      e.save!
    rescue StandardError
      create_log('events', "#{court_case.case_number} resulted in an error when creating the event", event_data)
    end
  end

  def find_event(event_data)
    Event
      .find_or_initialize_by({
                               court_case_id: court_case.id,
                               event_at: event_data[:date],
                               party_id: party_id(event_data[:party_name].squish)
                             })
  end
end
