require 'rails_helper'

RSpec.describe OkElection::VotingMethod, type: :model do
  describe 'associations' do
    it { should have_many(:votes).class_name('OkElection::Vote').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
  end  
end
