class TulsaBlotter::Inmate < ApplicationRecord
  belongs_to :roster, optional: true
  has_many :arrests, class_name: 'TulsaBlotter::Arrest',foreign_key: 'inmate_id'
  validates :first, :middle, :last, :gender, presence: true
end
