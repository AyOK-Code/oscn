require 'rails_helper'

RSpec.describe OkElection::Precinct, type: :model do
  describe 'associations' do
    it { should belong_to(:county) }
    it { should have_many(:voters).class_name('OkElection::Voter').dependent(:destroy) }
    it { should have_many(:votes).through(:voters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:congressional_district) }
    it { should validate_presence_of(:state_senate_district) }
    it { should validate_presence_of(:state_house_district) }
    it { should validate_presence_of(:county_commissioner) }
  end
end
