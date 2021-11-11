require 'rails_helper'

RSpec.describe Judge, type: :model do
  context 'associations' do
    it { should belong_to(:county) }
    it { should have_many(:court_cases).with_foreign_key('current_judge_id') }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
