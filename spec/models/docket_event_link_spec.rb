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

  describe 'scopes' do
    describe '#pdf' do
      it 'filters for just PDF files' do
        pdf_link = create(:docket_event_link, title: 'PDF')
        non_pdf_link = create(:docket_event_link, title: 'HTML')

        expect(DocketEventLink.pdf).to eq([pdf_link])
      end
    end

    describe '#without_attached_file' do
      it 'filters for links without attached files' do
        link_with_file = create(:docket_event_link, :with_file)
        link_without_file = create(:docket_event_link)

        expect(DocketEventLink.without_attached_file).to eq([link_without_file])
      end
    end
  end
end
