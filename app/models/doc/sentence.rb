class Doc::Sentence < ApplicationRecord
  belongs_to :profile, class_name: 'Doc::Profile', foreign_key: 'doc_profile_id'
  belongs_to :offense_code, class_name: 'Doc::OffenseCode', optional: true, foreign_key: 'doc_offense_code_id'
  belongs_to :court_case, optional: true
end
