class Judge < ApplicationRecord
  belongs_to :county, optional: true
  has_many :court_cases, foreign_key: 'current_judge_id'
  validates :name, presence: true

  def first_last
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    end
  end
end
