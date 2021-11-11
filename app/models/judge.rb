class Judge < ApplicationRecord
  belongs_to :county
  has_many :court_cases, foreign_key: 'current_judge_id'
  validates :name, presence: true
end
