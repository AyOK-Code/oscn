require 'rails_helper'

RSpec.describe ZipCode, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:datas).dependent(:destroy) }
  end
end
