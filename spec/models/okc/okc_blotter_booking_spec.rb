require 'rails_helper'

RSpec.describe OkcBlotter::Booking, type: :model do
  describe 'associations' do
    it { should belong_to(:pdf).class_name('OkcBlotter::Pdf') }
    it { should have_many(:offenses).dependent(:destroy) }
    it { should belong_to(:roster).class_name('Roster').optional }
  end
end
