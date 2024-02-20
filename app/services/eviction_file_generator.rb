require 'csv'
require 'tempfile'

class EvictionFileGenerator
  attr_reader :eviction_letters, :date

  def initialize(date)
    @date = date
    @eviction_letters = EvictionLetter.file_pull(date)
  end

  def self.generate(date)
    new(date).generate
  end

  def generate
    csv_string = CSV.generate do |csv|
      csv << add_headers

      eviction_letters.each do |eviction_letter|
        csv << add_row(eviction_letter)
      end
    end

    # Create and write to a temporary file
    temp_file = Tempfile.new(['eviction_letters', '.csv'])
    temp_file.write(csv_string)
    temp_file.close

    # Output the path to the tempfile for reference
    puts "CSV file generated at: #{temp_file.path}"

    # Ensure you return the file path if needed generateelsewhere
    temp_file.path

    # Save to EvictionFile
    eviction_file = EvictionFile.new
    eviction_file.sent_at = date
    eviction_file.file.attach(io: File.open(temp_file.path), filename: "eviction_letters_#{Time.zone.now.to_date}.csv")
    # Mail to quickprint
    eviction_file.save
  end

  private

  def add_headers
    %w[First Last Company Address1 Address2 City State Zip CaseNumber Defendants ScheduledCourtDate CaseLink]
  end

  def add_row(eviction_letter)
    [
      eviction_letter.first_defendant.first_name,
      eviction_letter.first_defendant.last_name,
      '', # Company: Placeholder
      eviction_letter.validation_usps_address,
      '', # Address2: Placeholder
      eviction_letter.validation_city,
      eviction_letter.validation_state,
      eviction_letter.validation_zip_code,
      eviction_letter.docket_event_link.docket_event.court_case.case_number,
      eviction_letter.full_name,
      eviction_letter.docket_event_link.docket_event.court_case.events.first&.event_at,
      eviction_letter.docket_event_link.docket_event.court_case.oscn_link
    ]
  end
end
