require 'rails_helper'

RSpec.describe OkAssessor::ImprovementDetail, type: :model do
  describe 'associations' do
    it { should belong_to(:improvement).class_name('OkAssessor::Improvement') }
  end
end
