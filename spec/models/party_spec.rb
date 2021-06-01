require 'rails_helper'

RSpec.describe Party, type: :model do
  context 'associations' do
    it { should belong_to(:party_type) }
    it { should have_many(:case_parties).dependent(:destroy) }
    it { should have_many(:cases).through(:case_parties) }
    it { should have_many(:counsel_parties).dependent(:destroy) }
    it { should have_many(:counsels).through(:counsel_parties) }
  end
end
