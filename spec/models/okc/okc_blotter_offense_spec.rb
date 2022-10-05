require 'rails_helper'

RSpec.describe OkcBlotter::Offense, type: :model do
  describe 'associations' do
    it { should belong_to(:booking).class_name('OkcBlotter::Booking') }
  end
end
