require 'rails_helper'

RSpec.describe TulsaBlotter::Offense, type: :model do
  describe 'associations' do
    it { should belong_to(:arrest).class_name('TulsaBlotter::Arrest') }
  end
end
