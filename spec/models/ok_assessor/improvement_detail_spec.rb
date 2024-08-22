require 'rails_helper'

RSpec.describe OkAssessor::ImprovementDetail, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('OkAssessor::Account') }
  end
end
