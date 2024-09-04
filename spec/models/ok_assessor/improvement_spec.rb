require 'rails_helper'

RSpec.describe OkAssessor::Improvement, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('OkAssessor::Account') }
    it { should have_many(:improvement_details).class_name('OkAssessor::ImprovementDetail') }
  end
end
