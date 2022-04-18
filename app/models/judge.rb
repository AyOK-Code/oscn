class Judge < ApplicationRecord
  belongs_to :county, optional: true
  has_many :court_cases, foreign_key: 'current_judge_id'
  validates :name, presence: true

  def first_last
    "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
