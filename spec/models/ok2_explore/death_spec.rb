require 'rails_helper'

RSpec.describe Ok2Explore::Death, type: :model do
  describe 'associations' do
    it { should belong_to(:county) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should define_enum_for(:sex) }
    it { should validate_presence_of(:death_on) }
  end
end
