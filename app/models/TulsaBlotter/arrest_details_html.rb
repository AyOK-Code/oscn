class TulsaBlotter::ArrestDetailsHtml < ApplicationRecord
  belongs_to :arrest, class_name: 'TulsaBlotter::Arrest'
end
