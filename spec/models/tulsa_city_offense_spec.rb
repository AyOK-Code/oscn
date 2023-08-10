require 'rails_helper'

RSpec.describe TulsaCity::Offense do
  describe 'associations' do
    it { is_expected.to belong_to(:inmate).class_name('TulsaCity::Inmate') }
  end
end
