class PartyHtml < ApplicationRecord
  belongs_to :party

  validates :html, :scraped_at, presence: true
end
