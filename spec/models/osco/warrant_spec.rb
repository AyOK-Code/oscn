require 'rails_helper'

RSpec.describe Osco::Warrant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:case_number) }
  end
end
