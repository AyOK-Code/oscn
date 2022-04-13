require 'rails_helper'

RSpec.describe Judge, type: :model do
  context 'associations' do
    it { should belong_to(:county).optional }
    it { should have_many(:court_cases).with_foreign_key('current_judge_id') }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#first_last' do
    it 'returns a concatented string of the first and last name of the judge' do
      skip
    end
  end
end
