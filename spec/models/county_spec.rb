require 'rails_helper'

RSpec.describe County, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fips_code) }
  end
end
