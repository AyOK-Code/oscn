require 'rails_helper'

RSpec.describe OkcBlotter::Pdf, type: :model do
  describe 'validations' do
    it { should have_many(:bookings).dependent(:destroy) }
  end
end
