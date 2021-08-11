require 'uri'

module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class CourtCase
    attr_accessor :logs, :court_case, :parsed_html
    attr_reader :data

    def initialize(case_number)
      @court_case = ::CourtCase.find_by(case_number: case_number)
      @parsed_html = Nokogiri::HTML(court_case.case_html.html)
      @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
      @logs = ::Importers::Logger.new(court_case)
    end

    def self.perform(case_number)
      new(case_number).perform
    end

    def perform
      return if parsed_html.css('.errorMessage').count > 0
      ActiveRecord::Base.transaction do
        court_case.update(filed_on: data[:filed_on], closed_on: data[:closed_on])
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
