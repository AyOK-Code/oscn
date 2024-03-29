class Count < ApplicationRecord
  belongs_to :court_case
  belongs_to :party
  belongs_to :plea, optional: true
  belongs_to :verdict, optional: true
  belongs_to :filed_statute_code, class_name: 'CountCode'
  belongs_to :disposed_statute_code, class_name: 'CountCode', optional: true

  validates :filed_statute_violation, presence: true
end
