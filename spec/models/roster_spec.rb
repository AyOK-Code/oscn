require 'rails_helper'

RSpec.describe Roster, type: :model do
  describe 'associations' do
    it { should have_many(:booking)}
    it { should have_many(:case_parties)}
    it { should have_many(:doc_profiles)}
  end
  
end
