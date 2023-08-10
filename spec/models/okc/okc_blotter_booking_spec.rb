require 'rails_helper'

RSpec.describe OkcBlotter::Booking do
  describe 'associations' do
    it { is_expected.to belong_to(:pdf).class_name('OkcBlotter::Pdf') }
    it { is_expected.to have_many(:offenses).dependent(:destroy) }
    it { is_expected.to belong_to(:roster).class_name('Roster').optional }
  end
end
