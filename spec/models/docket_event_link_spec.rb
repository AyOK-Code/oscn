require 'rails_helper'

RSpec.describe DocketEventLink, type: :model do
  describe 'associations' do
    it { should belong_to(:docket_event) }
  end
  describe 'validations' do
    it { should validate_presence_of(:oscn_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:link) }
  end
end
