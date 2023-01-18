class TulsaCity::Inmate < ApplicationRecord
    has_many :tulsa_city_offenses, class_name: 'TulsaCity::Offense', dependent: :destroy,foreign_key: 'tulsa_city_inmates_id'
end
