class DocketEventType < ApplicationRecord
  WARRANT_CODES = ['WAI$', 'BWIFAP', 'BWIFA', 'BWIFC', 'BWIAR', 'BWIAA', 'BWICA', 'BWIFAR', 'BWIFAA', 'BWIFP', 'BWIMW', 'BWIR8', 'BWIS', 'BWIS$', 'WAI', 'WAIMV', 'WAIMW', 'BWIFAR']

  has_many :docket_events, dependent: :destroy

  validates :code, uniqueness: true
  # TODO: validate code presence
  # TODO: Change "" to "Blank"
end
