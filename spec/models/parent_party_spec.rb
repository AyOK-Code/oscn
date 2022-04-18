require 'rails_helper'

RSpec.describe ParentParty, type: :model do
  describe 'associations' do
    it { should have_many(:parties) }
  end
end
