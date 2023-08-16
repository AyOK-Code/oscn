require 'rails_helper'

RSpec.describe TulsaBlotter::Offense do
  describe 'associations' do
    it { is_expected.to belong_to(:arrest).class_name('TulsaBlotter::Arrest') }
  end
end
