require 'rails_helper'

RSpec.describe TulsaCity::Offense, type: :model do
  describe 'associations' do
    it { should belong_to(:tulsa_city_inmates).class_name('TulsaCity::Inmate') }
  end
end
