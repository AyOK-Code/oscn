class CaseHtml < ApplicationRecord
  belongs_to :court_case

  validates :html, :scraped_at, presence: true
end
