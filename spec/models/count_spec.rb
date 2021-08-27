require 'rails_helper'

RSpec.describe Count, type: :model do
  context 'associations' do
    it { should belong_to(:court_case) }
    it { should belong_to(:party) }
    it { should belong_to(:plea).optional }
    it { should belong_to(:verdict).optional }
  end

  context 'validations' do
    it { should validate_presence_of(:filed_statute_violation) }
  end
end
