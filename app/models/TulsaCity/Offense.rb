class TulsaCity::Offense < ApplicationRecord
    belongs_to :tulsa_city_inmates, class_name: 'TulsaCity::Inmate' ,foreign_key: :tulsa_city_inmates_id
end
