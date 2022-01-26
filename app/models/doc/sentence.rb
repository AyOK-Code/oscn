class Doc::Sentence < ApplicationRecord
  belongs_to :doc_profile, class_name: 'Doc::Profile'
  belongs_to :doc_offense_code, class_name: 'Doc::OffenseCode', optional: true
end
