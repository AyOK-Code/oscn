require 'rails_helper'

RSpec.describe OkcBlotter::Offense do
  describe 'associations' do
    it { is_expected.to belong_to(:booking).class_name('OkcBlotter::Booking') }
  end
end
