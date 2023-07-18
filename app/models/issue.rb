class Issue < ApplicationRecord
  belongs_to :court_case
  belongs_to :count_code
  has_many :issue_parties, dependent: :destroy
end
