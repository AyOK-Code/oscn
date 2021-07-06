require 'rails_helper'

RSpec.describe DocketEventType, type: :model do
  context 'associations' do
    it { should have_many(:docket_events).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_uniqueness_of(:code) }
  end
end
