class EvictionLetter < ApplicationRecord
  belongs_to :docket_event_link

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

  def full_name
    docket_event_link.docket_event.court_case.defendants.map(&:full_name).join(', ')
  end
end
