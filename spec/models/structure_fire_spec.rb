require 'rails_helper'

RSpec.describe StructureFire, type: :model do
  describe 'associations' do
    it { should belong_to(:structure_fire_link) }
  end

  describe 'validations' do
    it { should validate_presence_of(:incident_number) }
    it { should validate_presence_of(:incident_type) }
    it { should validate_presence_of(:station) }
    it { should validate_presence_of(:incident_date) }
    it { should validate_presence_of(:street_number) }
    it { should validate_presence_of(:street_prefix) }
    it { should validate_presence_of(:street_name) }
    it { should validate_presence_of(:street_type) }
  end
end
