require 'uri'
module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class CourtCase
    attr_accessor :logs, :court_case
    attr_reader :data

    def initialize(case_object)
      @court_case = case_object
      @parsed_html = Nokogiri::HTML(court_case.case_html.html)
      @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
      @logs = ::Importers::Logger.new(case_object)
    end

    def self.perform(case_object)
      new(case_object).perform
    end

    def perform
      ActiveRecord::Base.transaction do
        court_case.update(closed_on: data[:closed_on])
        ::Importers::Party.perform(data[:parties], court_case, logs)
        # ::Importers::Judge.perform(data[:judge], court_case, logs)
        ::Importers::Count.perform(data[:counts], court_case, logs)
        ::Importers::Event.perform(data[:events], court_case, logs)
        ::Importers::Attorney.perform(data[:attorneys], court_case, logs)
        ::Importers::DocketEvent.perform(data[:docket_events], court_case, logs)
        logs.update_logs
      end
    end
  end
end
