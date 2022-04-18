require 'rails_helper'

RSpec.describe DocketEventType, type: :model do
  describe 'associations' do
    it { should have_many(:docket_events).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:code) }
  end
end
