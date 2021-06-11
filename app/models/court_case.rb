class CourtCase < ApplicationRecord
  belongs_to :county
  belongs_to :case_type
  has_many :case_parties, dependent: :destroy
  has_many :parties, through: :case_parties
  has_many :counts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, through: :counsel_parties
  has_one :case_html, dependent: :destroy

  validates :oscn_id, :case_number, :filed_on, presence: true

  scope :without_html, -> { joins(:case_html).where(case_htmls: { html: nil }) }
  scope :with_html, -> { joins(:case_html).where.not(case_htmls: { html: nil }) }
  scope :without_parties, -> { left_outer_joins(:case_parties).where(case_parties: { id: nil }) }
  scope :valid, -> { where.not("case_number LIKE '%-0'") }
  scope :felonies, -> { where("case_number LIKE 'CF-%'") }
  scope :non_felonies, -> { where.not("case_number LIKE 'CF-%'") }

  def html
    case_html.html
  end
end
