require 'rails_helper'

RSpec.describe OkSos::CorpType, type: :model do
  describe 'associations' do
    it { should have_many(:associated_entities).class_name('OkSos::AssociatedEntity') }
    it { should have_many(:entities).class_name('OkSos::Entity') }
  end

  describe 'validations' do
    it { should validate_presence_of(:corp_type_id) }
    it { should validate_presence_of(:corp_type_description) }
  end
end
