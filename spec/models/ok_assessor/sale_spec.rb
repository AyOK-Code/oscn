require 'rails_helper'

RSpec.describe OkAssessor::Sale, type: :model do
  describe 'associations' do
    it { should belong_to(:account).class_name('OkAssessor::Account') }
  end
end
