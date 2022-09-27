require 'rails_helper'

RSpec.describe TulsaBlotter::Offense, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:case_number) }
    it { should validate_presence_of(:court_date) }
    it { should validate_presence_of(:bond_type) }
    it { should validate_presence_of(:disposition) }
  end
end
