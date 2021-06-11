class CaseHtml < ApplicationRecord
  belongs_to :court_case

  # TODO: validate presence of html, scraped_at
end
