require 'rails_helper'

RSpec.describe County, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fips_code) }
  end

  context 'associations' do
    it { should have_many(:court_cases).dependent(:destroy) }
  end
end
