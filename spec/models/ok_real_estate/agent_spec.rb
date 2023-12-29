require 'rails_helper'

RSpec.describe OkRealEstate::Agent, type: :model do
  describe 'associations' do
    it { should have_many(:places).class_name('OkRealEstate::Place').dependent(:destroy) }
    it { should have_many(:histories).class_name('OkRealEstate::History').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:license_number) }
    it { should validate_presence_of(:license_expiration_on) }
  end
end
