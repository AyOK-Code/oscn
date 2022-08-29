require 'rails_helper'

RSpec.describe OkcBlotterBooking, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:pdf_id) }
    it { should validate_presence_of(:transient) }
    it { should validate_presence_of(:inmate_number) }
    it { should validate_presence_of(:booking_number) }
    it { should validate_presence_of(:booking_date) }

  end
end
