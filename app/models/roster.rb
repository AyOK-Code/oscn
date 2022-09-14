class Roster < ApplicationRecord
  has_many :booking, foreign_key: 'roster_id'
  has_many :case_parties, foreign_key: 'roster_id'
  has_many :doc_profiles, foreign_key: 'roster_id'
end
