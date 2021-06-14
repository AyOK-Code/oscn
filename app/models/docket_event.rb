class DocketEvent < ApplicationRecord
  belongs_to :court_case
  belongs_to :docket_event_type
  belongs_to :party, optional: true
  has_one :warrant
  validates :event_on, :description, presence: true

  scope :for_code, ->(code) { joins(:docket_event_type).where(docket_event_types: { code: code }) }
end
