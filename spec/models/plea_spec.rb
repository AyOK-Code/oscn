require 'rails_helper'

RSpec.describe Plea, type: :model do
  context 'associations' do
    it { should have_many(:counts).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
