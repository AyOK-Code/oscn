require 'rails_helper'

RSpec.describe PartyAlias do
  describe 'associations' do
    it { is_expected.to belong_to(:party) }
  end

  describe 'associations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
