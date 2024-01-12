class StructureFireLink < ApplicationRecord
  has_one_attached :pdf
  validates :pdf_date_on, :url, presence: true

  scope :without_attached_file, -> { left_joins(:pdf_attachment).where('active_storage_attachments.id IS NULL') }
end
