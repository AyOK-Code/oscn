class StructureFireLink < ApplicationRecord
  has_one_attached :pdf
  validates :pdf_date_on, :external_url, presence: true

  scope :without_attached_file, -> { left_joins(:pdf_attachment).where('active_storage_attachments.id IS NULL') }

  enum status: { 
    pending: 0, 
    complete: 1, 
    error: 2
  }
end
