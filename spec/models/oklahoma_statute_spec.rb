require 'rails_helper'

RSpec.describe OklahomaStatute, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:ten_digit) }
    it { should validate_presence_of(:severity) }
    it { should validate_presence_of(:description) }
  end
end
