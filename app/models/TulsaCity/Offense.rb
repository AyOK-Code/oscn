class TulsaCity::Offense < ApplicationRecord
  belongs_to :inmate, class_name: 'TulsaCity::Inmate', foreign_key: :inmate_id
end
