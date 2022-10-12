class TulsaBlotter::Arrest < ApplicationRecord
  has_many :offenses, class_name: 'TulsaBlotter::Offense', foreign_key: 'arrests_id'
end
