require 'rails_helper'

RSpec.describe DistrictAttorney, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:counties)}
  end
end
