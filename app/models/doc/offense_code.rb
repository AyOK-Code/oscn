class Doc::OffenseCode < ApplicationRecord
  has_many :sentences, dependent: :destroy

  validates :statute_code, :description, presence: true
end
