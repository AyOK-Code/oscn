require 'rails_helper'

RSpec.describe TulsaBlotter::Arrest do
  describe 'associations' do
    it { is_expected.to have_many(:offenses).class_name('TulsaBlotter::Offense') }
  end
end
