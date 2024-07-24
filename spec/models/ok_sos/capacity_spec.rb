require 'rails_helper'

RSpec.describe OkSos::Capacity, type: :model do
  describe 'associations' do
    it { should have_many(:associated_entities).class_name('OkSos::AssociatedEntity') }
  end

  describe 'validations' do
    it { should validate_presence_of(:capacity_id) }
    it { should validate_presence_of(:description) }
  end
end
