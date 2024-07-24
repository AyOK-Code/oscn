require 'rails_helper'

RSpec.describe OkSos::Suffix, type: :model do
  describe 'associations' do
    it { should have_many(:officers).class_name('OkSos::Officer') }
  end

  describe 'validations' do
    it { should validate_presence_of(:suffix_id) }
    it { should validate_presence_of(:suffix) }
  end
end
