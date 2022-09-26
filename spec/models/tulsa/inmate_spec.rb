require 'rails_helper'

RSpec.describe TulsaBlotter::Inmate, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first) }
    it { should validate_presence_of(:middle) }
    it { should validate_presence_of(:last) }
    it { should validate_presence_of(:gender) }
  end

  describe 'associations' do
    it { should belong_to(:roster).class_name('Roster').optional }
    it { should have_many(:tulsa_blotter_arrests) }
  end
end
