class Doc::Profile < ApplicationRecord

  validates :doc_number, :status, :sex, presence: true

  enum status: [:active, :inactive]
  enum sex: [:male, :female]
end
