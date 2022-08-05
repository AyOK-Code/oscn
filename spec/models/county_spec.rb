require 'rails_helper'

RSpec.describe County, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fips_code) }
  end

  describe 'associations' do
    it { should have_many(:court_cases).dependent(:destroy) }
    it { should belong_to(:district_attorney).class_name('DistrictAttorney').optional }
  end
end
