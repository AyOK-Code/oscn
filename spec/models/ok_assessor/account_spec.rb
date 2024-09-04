require 'rails_helper'

RSpec.describe OkAssessor::Account, type: :model do
  describe 'associations' do
    it { should have_many(:improvements).class_name('OkAssessor::Improvement').dependent(:destroy) }
    it { should have_many(:land_attributes).class_name('OkAssessor::LandAttribute').dependent(:destroy) }
    it { should have_many(:sales).class_name('OkAssessor::Sale').dependent(:destroy) }
    it { should have_many(:value_details).class_name('OkAssessor::ValueDetail').dependent(:destroy) }
  end
end
