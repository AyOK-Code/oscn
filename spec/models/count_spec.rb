require 'rails_helper'

RSpec.describe Count, type: :model do
  context 'associations' do
    it { should belong_to(:case) }
    it { should belong_to(:party) }
    it { should belong_to(:plea).optional }
    it { should belong_to(:verdict).optional }
  end
end
