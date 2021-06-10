require 'uri'
# Takes the data from the OscnScraper and imports it into the database
class CaseImporter
  def initialize(case_object)
    @court_case = case_object
    @parsed_html = Nokogiri::HTML(court_case.html)
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
      Importer::Party.perform(data[:parties])
      Importer::Count.perform(data[:counts])
      Importer::Event.perform(data[:events])
      Importer::Attorney.perform(data[:attorneys])
      Importer::DocketEvent.perform(data[:docket_events])

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
      court_case.update(logs: logs)
    else
      court_case.update(logs: nil)
    end
  end

  def save_docket_event(docket_event_data)
    de = DocketEvent.find_or_initialize_by(court_case_id: court_case.id, event_on: docket_event_data[:date], docket_event_type_id: find_or_create_docket_event_type(docket_event_data[:code]))
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

  def find_or_create_docket_event_type(docket_event_type)
    docket_event_type_id = docket_event_types[docket_event_type]
    return nil if docket_event_type.nil?

    return docket_event_type_id if docket_event_type_id

    new_docket_event_type = DocketEventType.create(code: docket_event_type)
  end

  def parse_id(link)
    uri = URI(link)
    params = CGI.parse(uri.query)
    params['id'].first.to_i
  end
end
