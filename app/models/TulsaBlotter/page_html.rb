class TulsaBlotter::PageHtml < ApplicationRecord
  has_and_belongs_to_many :arrests, class_name: 'TulsaBlotter::Arrest'
end
