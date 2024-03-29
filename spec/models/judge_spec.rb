require 'rails_helper'

RSpec.describe Judge, type: :model do
  describe 'associations' do
    it { should belong_to(:county).optional }
    it { should have_many(:court_cases).with_foreign_key('current_judge_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#first_last' do
    it 'returns a concatented string of the first and last name of the judge' do
      judge = create(:judge, first_name: 'Bilbo', last_name: 'Baggins')
      expect(judge.first_last).to eq('Bilbo Baggins')
    end
  end
end
