require 'rails_helper'

RSpec.describe OkcBlotter::Pdf do
  describe 'validations' do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
  end
end
