class Doc::OffenseCode < ApplicationRecord
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_offense_code_id', dependent: :destroy

  validates :statute_code, :description, presence: true
end
