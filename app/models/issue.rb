class Issue < ApplicationRecord
  belongs_to :court_case
  belongs_to :count_code
  belongs_to :filed_by, class_name: 'Party'
  has_many :issue_parties, dependent: :destroy
end
