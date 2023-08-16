require 'rails_helper'

RSpec.describe ParentParty do
  describe 'associations' do
    it { is_expected.to have_many(:parties) }
  end
end
