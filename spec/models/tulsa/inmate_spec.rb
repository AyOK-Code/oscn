require 'rails_helper'

RSpec.describe TulsaBlotter::Inmate, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:dlm) }
  end

  describe 'associations' do
    it { should belong_to(:roster).class_name('Roster').optional }
    it { should have_many(:arrests).class_name('TulsaBlotter::Arrest') }
  end
end
