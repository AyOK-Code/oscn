require 'rails_helper'

RSpec.describe OkSos::NameType, type: :model do
  describe 'associations' do
    it { should have_many(:names).class_name('OkSos::Name') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name_type_id) }
    it { should validate_presence_of(:name_description) }
  end
end
