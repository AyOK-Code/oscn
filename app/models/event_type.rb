class EventType < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :oscn_id, :code, :name, presence: true
end
