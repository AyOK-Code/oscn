class Party < ApplicationRecord
  belongs_to :party_type
  has_many :case_parties, dependent: :destroy
  has_many :court_cases, through: :case_parties
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, through: :counsel_parties
  has_many :docket_events, dependent: :destroy
  has_many :addresses, class_name: 'PartyAddress', dependent: :destroy

  validates :oscn_id, presence: true
  validates :oscn_id, uniqueness: { case_sensitive: true }
  validates :birth_month, inclusion: 1..12, allow_nil: true
  validates :birth_year, inclusion: 1800..DateTime.current.year, allow_nil: true

  scope :without_birthday, -> { where(birth_month: nil) } # TODO: Validate presence of party_type?
  scope :defendant, -> { joins(:party_type).where(party_types: { name: 'defendant' }) }
end
