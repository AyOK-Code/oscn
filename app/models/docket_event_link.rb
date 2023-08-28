class DocketEventLink < ApplicationRecord
  belongs_to :docket_event
  validates :oscn_id, :title, :link, presence: true

  has_one_attached :document, dependent: :destroy

  scope :pdf, -> { where(title: 'PDF') }
  scope :without_attached_file, -> { left_joins(:document_attachment).where('active_storage_attachments.id IS NULL') }
end
