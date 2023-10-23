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

  def full_name
    docket_event_link.docket_event.court_case.defendants.map{|d| d.full_name}.join(', ')
  end
end
