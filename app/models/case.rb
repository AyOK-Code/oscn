class Case < ApplicationRecord
  belongs_to :county
  belongs_to :case_type

  validates :oscn_id, :case_number, :filed_on, :html, presence: true
end
