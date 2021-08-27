class Judge < ApplicationRecord
  belongs_to :county
  has_many :court_cases
  validates :name, presence: true
end
