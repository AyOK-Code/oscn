require 'rails_helper'

RSpec.describe OkcBlotter::Booking, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:transient) }
    it { should validate_presence_of(:inmate_number) }
    it { should validate_presence_of(:booking_number) }
    it { should validate_presence_of(:booking_date) }
  end
  describe 'associations' do
    it { should belong_to(:pdf).class_name('OkcBlotter::Pdf') }
  end
end
