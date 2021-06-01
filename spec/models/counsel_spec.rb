require 'rails_helper'

RSpec.describe Counsel, type: :model do
  context 'associations' do
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:parties).through(:counsel_parties) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
