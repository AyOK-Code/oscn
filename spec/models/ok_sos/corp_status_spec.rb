require 'rails_helper'

RSpec.describe OkSos::CorpStatus, type: :model do
  describe 'associations' do
    it { should have_many(:entities).class_name('OkSos::Entity').with_foreign_key('status_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:status_id) }
    it { should validate_presence_of(:status_description) }
  end
end
