class Doc::Alias < ApplicationRecord
  belongs_to :doc_profile, class_name: 'Doc::Profile'
end
