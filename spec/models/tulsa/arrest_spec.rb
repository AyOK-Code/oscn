require 'rails_helper'

RSpec.describe TulsaBlotter::Arrest, type: :model do
  describe 'validations' do
    binding.pry
    it { should validate_presence_of(:arrest_date) }
    it { should validate_presence_of(:arrest_time) }
    it { should validate_presence_of(:arrested_by) }
  end

  describe 'associations' do
    it { should belong_to(:tulsa_blotter_inmate).class_name('TulsaBlotter::Inmate').optional }
    it { should have_many(:tulsa_blotter_tulsa_offenses).class_name('TulsaBlotter::TulsaOffense') }
  end
end
