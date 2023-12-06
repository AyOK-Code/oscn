class StructureFireLink < ApplicationRecord
  has_one_attached :pdf
  validates :date, :url, presence: true
end
