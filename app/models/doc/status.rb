class Doc::Status < ApplicationRecord
  belongs_to :profile, class_name: 'Doc::Profile', foreign_key: 'doc_profile_id'
end
