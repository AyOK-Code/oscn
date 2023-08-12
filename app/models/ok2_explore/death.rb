class Ok2Explore::Death < ApplicationRecord
  belongs_to :county

  validates :first_name, :last_name, :death_on, presence: true
  enum sex: [:male, :female]
end
