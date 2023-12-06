require 'rails_helper'

RSpec.describe StructureFire, type: :model do
  describe 'associations' do
    it { should belong_to(:structure_fire_link) }
  end

  describe 'validations' do
    it { should validate_presence_of(:incident_number) }
  end
end
