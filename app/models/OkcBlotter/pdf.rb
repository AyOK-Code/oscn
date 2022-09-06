class OkcBlotter::Pdf < ApplicationRecord
  has_many :booking, dependent: :destroy, foreign_key: 'pdfs_id'
end
