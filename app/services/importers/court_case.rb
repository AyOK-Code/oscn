require 'uri'

module Importers
  # Takes the data from the OscnScraper and imports it into the database
  class CourtCase
    attr_accessor :logs, :court_case, :parsed_html
    attr_reader :data

    def initialize(county_id, case_number)
      @court_case = ::CourtCase.find_by(county_id: county_id, case_number: case_number)
      @parsed_html = Nokogiri::HTML(court_case.case_html.html)
      @data = OscnScraper::Parsers::BaseParser.new(@parsed_html).build_object
      @logs = ::Importers::Logger.new(court_case)
    end

    def self.perform(county_id, case_number)
      new(county_id, case_number).perform
    end

    def perform
      return if parsed_html.css('.errorMessage').count.positive?

      ActiveRecord::Base.transaction do
        save_parties
        save_judges
        save_attorneys
        save_counts
        save_events
        save_docket_events
        logs.update_logs
        save_case
      end
    end

    def save_case
      court_case.update(filed_on: data[:filed_on], closed_on: data[:closed_on], is_error: court_case.check_is_error)
    end

    def save_parties
      ::Importers::Party.perform(data[:parties], court_case, logs)
    end

    def save_counts
      ::Importers::Count.perform(data[:counts], court_case, logs)
    end

    def save_judges
      ::Importers::Judge.perform(data[:judge], court_case, logs)
    end

    def save_events
      ::Importers::Event.perform(data[:events], court_case, logs)
    end

    def save_attorneys
      ::Importers::Attorney.perform(data[:attorneys], court_case, logs)
    end

    def save_docket_events
      ::Importers::DocketEvent.perform(data[:docket_events], court_case, logs)
    end
  end
end
