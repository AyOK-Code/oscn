require 'rails_helper'

RSpec.describe CaseParty do
  describe 'associations' do
    it { is_expected.to belong_to(:court_case) }
    it { is_expected.to belong_to(:party) }
    it { is_expected.to belong_to(:roster).class_name('Roster').optional }
  end

  describe 'validations' do
    subject { build(:case_party) }

    it { is_expected.to validate_uniqueness_of(:party_id).scoped_to(:court_case_id) }
  end
end
