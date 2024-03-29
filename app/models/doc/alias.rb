class Doc::Alias < ApplicationRecord
  belongs_to :doc_profile, class_name: 'Doc::Profile'

  validates :last_name, :doc_number, presence: true
end
