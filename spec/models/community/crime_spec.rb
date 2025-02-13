require 'rails_helper'

RSpec.describe Community::Crime, type: :model do
  describe 'associations' do
    it { should validate_presence_of(:incident_number) }
  end
end
