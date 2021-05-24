class Judge < ApplicationRecord
  belongs_to :county

  validates :name, :judge_type, presence: true
end
