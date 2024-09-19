module CaseHtmlValidator

  class CaseHtmlValidationError < StandardError
  end

  class Validate < ApplicationService
    attr_accessor :errors, :from_fixture

    CASE_COUNTY = 'Oklahoma'
    CASE_NUMBER = 'CM-2024-2809'

    def initialize(from_fixture: false)
      @errors = []
      @from_fixture = from_fixture
      @parsed_data = false
    end

    def retrieve_html
      begin
        OscnScraper::Requestor::Case
          .new({ county: CASE_COUNTY, number: CASE_NUMBER })
          .fetch_case_by_number
      rescue StandardError => e
        @errors << {
          section: "all",
          message: "Unable to fetch #{CASE_NUMBER} from oscn.net. Errror: #{e}",
        }
        raise CaseHtmlValidationError
      end
    end

    def parse_html(case_html)
      begin
        parsed_html = Nokogiri::HTML(case_html)
        OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
      rescue StandardError => e
        @errors << {
          section: "all",
          message: "Unable to parse html for #{CASE_NUMBER}. Error: #{e}",
        }
        raise CaseHtmlValidationError
      end
    end

    def parsed_data
      return @parsed_data if @parsed_data
      if from_fixture
        path = 'app/services/case_html_validator/expected/current_case_fixture.html'
        case_html = File.read(path)
      else
        case_html = retrieve_html
      end
      @parsed_data = parse_html(case_html)
      @parsed_data
    end

    def perform
      begin
        validate
      rescue CaseHtmlValidationError => e
        test = e
      end
      if @errors.length.zero?
        puts 'Case HTML parsed successfully'
      else
        handle_error
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
      file_path = "app/services/case_html_validator/expected/#{section.to_s}.json"
      begin
        expected = JSON.parse(File.read(file_path))
      rescue NoMethodError
        expected = File.read(file_path)
      end
      actual = JSON.parse(parsed_data[section].to_json)
      differences = Hashdiff.diff(expected, actual, indifferent: true)
      if differences.present?
        @errors << {
          section: section,
          message: "Parsed data for #{:section} did not match",
          differences: differences
        }
      end
    end

    def handle_error
      puts 'did not pass'
      email_error
    end

    def email_error
      CaseHtmlErrorMailer.error_email(@errors).deliver_now
    end
  end
end