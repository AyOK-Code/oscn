require 'rails_helper'

RSpec.describe OkSos::EntityAddress, type: :model do
  describe 'associations' do
    it { should belong_to(:zip_code).class_name('ZipCode').optional }
    it { should have_many(:officers).class_name('OkSos::Officer') }
  end
end
