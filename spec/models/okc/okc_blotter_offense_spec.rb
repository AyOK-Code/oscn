require 'rails_helper'

RSpec.describe OkcBlotter::Offense, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:charge) }
  end
end
