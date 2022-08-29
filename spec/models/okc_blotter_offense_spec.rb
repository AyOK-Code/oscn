require 'rails_helper'

RSpec.describe OkcBlotterOffense, type: :model do
  it { should validate_presence_of(:booking_id) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:charge) }
end
