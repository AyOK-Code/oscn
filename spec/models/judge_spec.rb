require 'rails_helper'

RSpec.describe Judge, type: :model do
  context 'associations' do
    it { should belong_to(:county) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:judge_type) }
  end
end
