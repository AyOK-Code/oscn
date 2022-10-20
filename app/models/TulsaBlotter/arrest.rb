class TulsaBlotter::Arrest < ApplicationRecord
  has_many :offenses, class_name: 'TulsaBlotter::Offense', foreign_key: 'arrests_id'
  has_and_belongs_to_many :page_htmls, class_name: 'TulsaBlotter::PageHtml'
  has_one :arrest_details_html, class_name: 'TulsaBlotter::ArrestDetailsHtml', foreign_key: 'arrest_id'

  validates :booking_id, presence: true
end
