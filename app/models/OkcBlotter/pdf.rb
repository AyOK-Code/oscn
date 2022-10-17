class OkcBlotter::Pdf < ApplicationRecord
  has_many :booking, dependent: :destroy, foreign_key: 'pdf_id'
end
