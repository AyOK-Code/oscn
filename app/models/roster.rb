class Roster < ApplicationRecord
  has_many :booking, dependent: :destroy, foreign_key: 'roster_id'
  has_many :case_parties, dependent: :destroy, foreign_key: 'roster_id'
  has_many :doc_profiles, dependent: :destroy, foreign_key: 'roster_id'
end
