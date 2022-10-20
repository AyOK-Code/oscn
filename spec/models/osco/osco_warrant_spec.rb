require 'rails_helper'

RSpec.describe Osco::Warrant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:case_number) }
  end
end
