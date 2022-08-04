class Doc::Profile < ApplicationRecord
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :aliases, class_name: 'Doc::Alias', foreign_key: 'doc_profile_id', dependent: :destroy
  has_many :statuses, class_name: 'Doc::Status', foreign_key: 'doc_profile_id', dependent: :destroy

  validates :last_name, :birth_date, :doc_number, :status, :sex, presence: true

  enum status: [:active, :inactive]
  enum sex: [:male, :female]

  def full_name
    puts full_name
    "#{last_name}, #{first_name} #{middle_name}"
  end
end
