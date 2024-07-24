require 'rails_helper'

RSpec.describe OkSos::NameStatus, type: :model do
  describe 'associations' do
    it { should have_many(:names).class_name('OkSos::Name') }
  end

  describe 'validations' do
    it { should validate_presence_of(:name_status_id) }
    it { should validate_presence_of(:description) }
  end
end
