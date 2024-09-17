module CaseHtmlValidator
  class Validate < ApplicationService
    attr_accessor :errors, :from_fixture

    CASE_COUNTY = 'Oklahoma'
    CASE_NUMBER = 'CM-2024-2809'

    def initialize(from_fixture: false)
      @errors = []
      @from_fixture = from_fixture
    end

    def parsed_data
      return @parsed_data if @parsed_data

      if from_fixture
        path = 'app/services/case_html_validator/expected_json/current_case_fixture.html'
        case_html = File.read(path)
      else
        case_html = OscnScraper::Requestor::Case
                      .new({ county: CASE_COUNTY, number: CASE_NUMBER })
                      .fetch_case_by_number
      end

      parsed_html = Nokogiri::HTML(case_html)
      @parsed_data = OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
    end

    def perform
      validate
      if @errors.length.zero?
        puts 'Case HTML parsed successfully'
      else
        puts @errors
      end
    end

    def validate
      validate_section(:parties)
      validate_section(:judge)
      validate_section(:attorneys)
      validate_section(:counts)
      validate_section(:issues)
      validate_section(:events)
      validate_section(:docket_events)
    end

    def validate_section(section)
      file_path = "app/services/case_html_validator/expected_json/#{section.to_s}.json"
      begin
        expected = JSON.parse(File.read(file_path)).map(&:with_indifferent_access).to_json
      rescue NoMethodError
        expected = File.read(file_path)
      end
      actual = parsed_data[section].to_json
      unless actual == expected
        @errors << {
          message: "Parsed data for #{:section} did not match",
          actual_json: actual,
          expected_json: expected
        }
      end
    end

    def handle_error
      puts 'did not pass'
      email_error
    end

    def email_error; end
  end
end