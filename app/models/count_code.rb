class CountCode < ApplicationRecord
  has_many :filed_counts, class_name: 'Count', foreign_key: 'filed_statute_code_id', dependent: :destroy
  has_many :disposed_counts, class_name: 'Count', foreign_key: 'disposed_statute_code_id', dependent: :destroy
  has_many :issues, dependent: :destroy

  validates :code, presence: true
end
