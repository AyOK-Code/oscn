require 'rails_helper'

RSpec.describe Party, type: :model do
  context 'associations' do
    it { should belong_to(:party_type) }
    it { should have_many(:case_parties).dependent(:destroy) }
    it { should have_many(:court_cases).through(:case_parties) }
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:counsels).through(:counsel_parties) }
  end

  context 'validations' do
    it { should validate_presence_of(:oscn_id) }
    subject { FactoryBot.build(:party) }
    it { should validate_uniqueness_of(:oscn_id) }
  end
end