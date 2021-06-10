class DocketEvent < ApplicationRecord
  belongs_to :court_case
  belongs_to :docket_event_type
  belongs_to :party, optional: true

  validates :event_on, :description, presence: true
end
