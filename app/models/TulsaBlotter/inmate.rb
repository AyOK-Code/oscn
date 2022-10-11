class TulsaBlotter::Inmate < ApplicationRecord
  belongs_to :roster, optional: true
  has_many :arrests, class_name: 'TulsaBlotter::Arrest', foreign_key: 'tulsa_blotter_inmates_id'
  validates :first, :middle, :last, :gender, presence: true
  has_and_belongs_to_many :page_htmls, class_name: 'TulsaBlotter::PageHtml'
  has_one :inmate_details_html, class_name: 'TulsaBlotter::InmateDetailsHtml'
end
