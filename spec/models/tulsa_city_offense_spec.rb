require 'rails_helper'

RSpec.describe TulsaCity::Offense, type: :model do
  describe 'associations' do
    it { should belong_to(:inmate).class_name('TulsaCity::Inmate') }
  end
end
