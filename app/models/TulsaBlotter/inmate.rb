class TulsaBlotter::Inmate < ApplicationRecord
  belongs_to :roster, optional: true
  has_many :arrests, class_name: 'TulsaBlotter::Arrest', foreign_key: 'tulsa_blotter_inmates_id'
  validates :dlm, presence: true
end
