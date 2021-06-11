class DocketEventType < ApplicationRecord
  has_many :docket_events, dependent: :destroy

  # TODO: validate code
  # TODO: Change "" to "Blank"
end
