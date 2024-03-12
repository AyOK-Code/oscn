class EvictionLetter < ApplicationRecord
  belongs_to :docket_event_link
  belongs_to :eviction_file, optional: true

  enum status: {
    pending: 0,
    extracted: 1,
    error: 2,
    validated: 3,
    mailed: 4,
    historical: 5 # No letter was sent
  }

  scope :missing_address_validation, -> { where(is_validated: false) }
  scope :has_address_validation, -> { where(is_validated: true) }
  scope :missing_extraction, -> { where(ocr_plaintiff_address: nil) }
  scope :has_extraction, -> { where.not(ocr_plaintiff_address: nil) }
  scope :past_day, -> { where('created_at >= ?', 1.day.ago) }
  scope :past_thirty_days, lambda {
                             joins(docket_event_link: :docket_event)
                               .where(docket_events: { event_on: 30.days.ago..Date.today })
                           }

  def self.calculate_dates(date)
    raise 'Invalid date: mailer only happens on M, W, F' unless date.monday? || date.wednesday? || date.friday?

    finish = date - 1.day
    start = if date.monday?
              date - 4.days
            else # for Wednesday and Friday
              date - 3.days
            end

    { start: start, finish: finish }
  end

  # Method to perform the file pull operation using the calculated dates
  def self.file_pull(date)
    dates = calculate_dates(date) # Get start and finish dates
    start = dates[:start]
    finish = dates[:finish]

    joins(docket_event_link: { docket_event: :court_case })
      .where(court_cases: { filed_on: start..finish })
  end

  def full_name
    docket_event_link.docket_event.court_case.defendants.map(&:full_name).join(', ')
  end

  def first_defendant
    docket_event_link.docket_event.court_case.defendants.first
  end
end
