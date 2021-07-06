class CourtCase < ApplicationRecord
  belongs_to :county
  belongs_to :case_type
  belongs_to :current_judge, class_name: 'Judge', foreign_key: 'current_judge_id', optional: true
  has_many :case_parties, dependent: :destroy
  has_many :parties, through: :case_parties
  has_many :counts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :counsel_parties, dependent: :destroy
  has_many :counsels, through: :counsel_parties
  has_many :docket_events, dependent: :destroy
  has_one :case_html, dependent: :destroy

  validates :oscn_id, :case_number, :filed_on, presence: true
  validates :oscn_id, uniqueness: true

  scope :without_html, -> { left_outer_joins(:case_html).where(case_htmls: { html: nil }) }
  scope :with_html, -> { joins(:case_html).where.not(case_htmls: { html: nil }) }
  scope :without_docket_events, -> { left_outer_joins(:docket_events).where(docket_events: { id: nil }) }
  scope :valid, -> { where.not("case_number LIKE '%-0'") }
  scope :active, -> { where(closed_on: nil) }
  scope :closed, -> { where.not(closed_on: nil) }
  scope :last_scraped, -> (date) { joins(:case_html).where(case_htmls: { scraped_at: date..DateTime.current }) }
  scope :older_than, -> (date) { joins(:case_html).where("case_htmls.scraped_at < ?", date)}
  # TODO: Make scope more dynamic to search for different errors
  scope :with_error, -> { where('logs @> ?', { docket_events: { message: 'DocketEventCountError' } }.to_json) }

  def html
    case_html.html
  end
end
