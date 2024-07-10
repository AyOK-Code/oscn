class Doc::SentencingCounty < ApplicationRecord
  belongs_to :county, optional: true
  has_many :sentences, class_name: 'Doc::Sentence', foreign_key: 'doc_sentencing_county_id'
  validates :name, presence: true
end
