class TulsaCity::Inmate < ApplicationRecord
    has_many :offenses, class_name: 'TulsaCity::Offense', dependent: :destroy ,foreign_key: 'inmate_id'
end
