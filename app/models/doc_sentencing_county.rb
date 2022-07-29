class DocSentencingCounty < ApplicationRecord
  belongs_to :county, optional: true
  validates :name, presence: true
end
