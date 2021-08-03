require 'uri'
module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class CourtCase
    attr_accessor :logs, :court_case, :docket_event_types, :pleas, :verdicts
    attr_reader :data

    def initialize(case_object, docket_event_types, pleas, verdicts)
      @court_case = case_object
      @parsed_html = Nokogiri::HTML(court_case.case_html.html)
      @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
      @logs = ::Importers::Logger.new(case_object)
      @docket_event_types = docket_event_types || DocketEventType.pluck(:code, :id).to_h
      @pleas = pleas || Plea.pluck(:name, :id).to_h
      @verdicts = verdicts || Verdict.pluck(:name, :id).to_h
    end

    def self.perform(case_object, docket_event_types, pleas, verdicts)
      new(case_object, docket_event_types, pleas, verdicts).perform
    end

    def perform
      ActiveRecord::Base.transaction do
        court_case.update(closed_on: data[:closed_on])
        ::Importers::Party.perform(data[:parties], court_case, logs)
        # ::Importers::Judge.perform(data[:judge], court_case, logs)
        ::Importers::Count.perform(data[:counts], court_case, pleas, verdicts, logs)
        ::Importers::Event.perform(data[:events], court_case, logs)
        ::Importers::Attorney.perform(data[:attorneys], court_case, logs)
        ::Importers::DocketEvent.perform(data[:docket_events], court_case, docket_event_types, logs)
        logs.update_logs
      end
    end
  end
end
