class TulsaBlotter::PageHtml < ApplicationRecord
  has_and_belongs_to_many :inmates, class_name: 'TulsaBlotter::Inmate'
end
