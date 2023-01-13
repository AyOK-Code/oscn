require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'update' do
  describe 'docket_event_links' do
    context 'attaches pdf to record' do
      let!(:test_docket_link) { create(:docket_event_link) }

      it 'it attaches pdf to record with active storage' do
        test_docket_link[:link] = 'https://www.oscn.net/dockets/GetDocument.aspx?ct=oklahoma&bc=1054046400&cn=CF-2022-1724&fmt=pdf'
        test_docket_link[:id] = 420
        test_docket_link[:title] = 'PDF'
        test_docket_link.save
        expect(test_docket_link.pdf.attached?).to be false
        VCR.use_cassette 'event_link_pdf' do
          Rake::Task['s3:docket_event_links'].invoke
        end

        expect(test_docket_link.reload.pdf).to be_attached
      end
    end
  end
end
