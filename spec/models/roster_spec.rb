require 'rails_helper'

RSpec.describe Roster, type: :model do
  describe 'associations' do
    it { should have_many(:bookings).class_name('OkcBlotter::Booking') }
    it { should have_many(:case_parties) }
    it { should have_many(:doc_profiles).class_name('Doc::Profile') }
  end
end
