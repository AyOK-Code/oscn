require 'rails_helper'

RSpec.describe TulsaCity::Inmate, type: :model do
  describe 'associations' do
    it { should have_many(:offenses) }
  end
end
