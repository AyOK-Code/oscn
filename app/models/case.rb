class Case < ApplicationRecord
  belongs_to :county
  belongs_to :case_type

  validates :oscn_id, :case_number, :filed_on, presence: true

  scope :without_html, -> { where(html: nil) }
  scope :with_html, -> { where.not(html: nil) }
end
