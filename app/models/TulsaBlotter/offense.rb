class TulsaBlotter::Offense < ApplicationRecord
  belongs_to :arrest, class_name: 'TulsaBlotter::Arrest', foreign_key: :arrests_id
end
