require 'rails_helper'

RSpec.describe OkRealEstate::Place, type: :model do
  describe 'associations' do
    it { should belong_to(:agent).class_name('OkRealEstate::Agent') }
  end

  describe 'validations' do
    it { should validate_presence_of(:external_id) }
  end
end
