require 'rails_helper'

RSpec.describe CaseParty, type: :model do
  describe 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
    it { should belong_to(:roster).class_name('Roster').optional }
  end

  describe 'validations' do
    subject { FactoryBot.build(:case_party) }

    it { should validate_uniqueness_of(:party_id).scoped_to(:court_case_id) }
  end
end
