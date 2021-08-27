class Event < ApplicationRecord
  belongs_to :court_case
  belongs_to :party, optional: true

  validates :event_at, presence: true
end
