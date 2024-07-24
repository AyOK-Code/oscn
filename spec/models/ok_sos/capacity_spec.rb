require 'rails_helper'

RSpec.describe OkSos::Capacity, type: :model do
  describe 'associations' do
    it { should have_many(:associated_entities).class_name('OkSos::AssociatedEntity') }
  end
end
