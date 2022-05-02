require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe 'associations' do
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:oscn_id) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
  end
end
