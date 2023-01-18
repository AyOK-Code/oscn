require 'rails_helper'

RSpec.describe TulsaCity::Inmate, type: :model do
  describe 'associations' do
    it { should have_many(:tulsa_city_offenses).class_name('TulsaCity::Offense') }
  end
end
