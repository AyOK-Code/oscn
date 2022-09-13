class Doc::Profile < ApplicationRecord
  belongs_to :roster, class_name: 'Roster', foreign_key: 'roster_id'
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :aliases, class_name: 'Doc::Alias', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :statuses, class_name: 'Doc::Status', foreign_key: 'doc_profile_id', dependent: :destroy

  validates :last_name, :birth_date, :doc_number, :status, :sex, presence: true

  enum status: [:active, :inactive]
  enum sex: [:male, :female]
end
