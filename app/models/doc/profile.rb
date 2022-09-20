class Doc::Profile < ApplicationRecord
  belongs_to :roster, optional: true
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :aliases, class_name: 'Doc::Alias', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :statuses, class_name: 'Doc::Status', foreign_key: 'doc_profile_id', dependent: :destroy

  validates :last_name, :birth_date, :doc_number, :status, :sex, presence: true

  enum status: [:active, :inactive]
  enum sex: [:male, :female]

  def to_roster
    {
      birth_year: birth_date.year,
      birth_month: birth_date.month,
      birth_day: birth_date.day,
      sex: sex,
      race: race,
      street_address: nil,
      zip: nil,
      first_name: first_name,
      last_name: last_name,
      middle_name: middle_name
    }
  end

  def roster_snapshot_date
    pdf.created_at #todo: update this
  end
end
