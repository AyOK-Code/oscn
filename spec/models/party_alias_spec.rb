require 'rails_helper'

RSpec.describe PartyAlias, type: :model do
  describe 'associations' do
    it { should belong_to(:party) }
  end

  describe 'associations' do
    it { should validate_presence_of(:name) }
  end
end
