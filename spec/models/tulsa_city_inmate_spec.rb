require 'rails_helper'

RSpec.describe TulsaCity::Inmate do
  describe 'associations' do
    it { is_expected.to have_many(:offenses) }
  end
end
