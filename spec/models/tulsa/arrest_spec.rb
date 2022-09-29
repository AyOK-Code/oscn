require 'rails_helper'

RSpec.describe TulsaBlotter::Arrest, type: :model do
  describe 'validations' do
  end

  describe 'associations' do
    it { should belong_to(:inmate).class_name('TulsaBlotter::Inmate') }
    it { should have_many(:offenses).class_name('TulsaBlotter::Offense') }
  end
end
