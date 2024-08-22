require 'rails_helper'

RSpec.describe OkAssessor::LandAttribute, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('OkAssessor::Account') }
  end
end
