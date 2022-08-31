class  Okc::OkcBlotterPdf < ApplicationRecord
    belongs_to :okc_booking, class_name: 'Okc::OkcBlotterBooking', foreign_key: 'okc_blotter_booking_id'
end
