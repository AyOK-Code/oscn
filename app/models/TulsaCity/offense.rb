class TulsaCity::Offense < ApplicationRecord
  belongs_to :inmate, class_name: 'TulsaCity::Inmate'
end
