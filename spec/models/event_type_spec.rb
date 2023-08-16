require 'rails_helper'

RSpec.describe EventType do
  describe 'associations' do
    it { is_expected.to have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:oscn_id) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
