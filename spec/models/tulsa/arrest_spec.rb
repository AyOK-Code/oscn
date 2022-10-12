require 'rails_helper'

RSpec.describe TulsaBlotter::Arrest, type: :model do
  describe 'associations' do
    it { should have_many(:offenses).class_name('TulsaBlotter::Offense') }
  end
end
