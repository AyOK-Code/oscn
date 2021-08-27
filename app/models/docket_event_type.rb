class DocketEventType < ApplicationRecord
  has_many :docket_events, dependent: :destroy

  validates :code, uniqueness: true
  # TODO: validate code presence
  # TODO: Change "" to "Blank"
end
