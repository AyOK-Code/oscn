class TulsaBlotter::InmateDetailsHtml < ApplicationRecord
  belongs_to :inmate, class_name: 'TulsaBlotter::Inmate'
end
