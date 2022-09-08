require 'rails_helper'

RSpec.describe OkcBlotter::Pdf, type: :model do
  describe 'validations' do
    it { should have_many(:booking).dependent(:destroy) }
  end
end
