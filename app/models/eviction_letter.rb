class EvictionLetter < ApplicationRecord
  belongs_to :docket_event_link

  enum status: {
    pending: 0,
    extracted: 1,
    error: 2,
    validated: 3,
    mailed: 4
  }

  # TODO: How to know what error occurred?
end
