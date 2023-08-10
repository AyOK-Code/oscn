class TulsaCity::Inmate < ApplicationRecord
  has_many :offenses, class_name: 'TulsaCity::Offense', dependent: :destroy
end
