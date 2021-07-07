class DocketEvent < ApplicationRecord
  belongs_to :court_case
  belongs_to :docket_event_type
  belongs_to :party, optional: true
  has_one :warrant, dependent: :destroy
  validates :event_on, presence: true

  scope :for_code, ->(code) { joins(:docket_event_type).where(docket_event_types: { code: code }) }
  scope :with_text, ->(string) { where('description LIKE :q', q: "%#{string}%")}
  scope :with_credit, -> { where.not(credit: 0) }
  scope :without_amount, -> { where(amount: 0) }
  scope :without_adjustment, -> { where(adjustment: 0) }
  scope :without_payment, -> { where(payment: 0) }
  scope :negative, -> { where('amount < 0') }
  scope :positive, -> { where('amount > 0') }
end
