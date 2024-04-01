require 'rails_helper'

RSpec.describe OkElection::Voter, type: :model do
  describe 'associations' do
    it { should belong_to(:precinct).class_name('OkElection::Precinct') }
    it { should have_many(:votes).class_name('OkElection::Vote').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:precinct_id) }
    it { should validate_presence_of(:voter_id) }
    it { should validate_presence_of(:political_affiliation) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:political_affiliation)
        .with_values(
          REP: 1,
          DEM: 2,
          IND: 3,
          LIB: 4
        )
    end

    it do
      should define_enum_for(:status)
        .with_values(
          inactive: 0,
          active: 1
        )
    end
  end
end
