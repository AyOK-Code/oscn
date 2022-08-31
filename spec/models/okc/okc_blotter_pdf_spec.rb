require 'rails_helper'

RSpec.describe Okc::OkcBlotterPdf, type: :model do
  describe 'associations' do
    it { should belong_to(:okc_booking).class_name('Okc::OkcBlotterBooking') }
  end
end
