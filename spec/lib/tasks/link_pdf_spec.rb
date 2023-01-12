require 'rails_helper'
require 'rake'

Rails.application.load_tasks

RSpec.describe 'update' do
  describe 'docket_event_links' do
    

    context 'when there are error cases and valid cases' do
        let!(:test_docket_link) { create(:docket_event_link) }
     

      it 'it updates is_error flag on error cases only' do
        test_docket_link[:link] = "https://www.oscn.net/dockets/GetDocument.aspx?ct=oklahoma&bc=1054046400&cn=CF-2022-1724&fmt=pdf"
        test_docket_link[:id] = 420
        test_docket_link[:title] = "PDF"
        test_docket_link.save
        binding.pry
        expect(test_docket_link.pdf.attached?).to be false
        VCR.use_cassette 'event_link_pdf' do
            Rake::Task['s3:docket_event_links'].invoke
          end

        binding.pry
        expect(test_docket_link.pdf.attached?).to be true
      end
    end
  end
end
