require 'rails_helper'

RSpec.describe DistrictAttorney do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:counties) }
  end
end
