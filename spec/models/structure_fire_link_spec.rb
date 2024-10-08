require 'rails_helper'

RSpec.describe StructureFireLink, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:pdf_date_on) }
    it { should validate_presence_of(:external_url) }
    it { should define_enum_for(:status) }
  end

  describe 'scopes' do
    describe '#without_pdf_file' do
      it 'filters for structure links without attached files' do
        create(:structure_fire_link, :with_file)
        structure_without = create(:structure_fire_link)
        expect(StructureFireLink.without_attached_file).to eq([structure_without])
      end
    end
  end
end
