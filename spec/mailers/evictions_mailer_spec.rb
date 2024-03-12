require 'rails_helper'

RSpec.describe EvictionsMailer, type: :mailer do
  describe 'file_email' do
    let(:eviction_file) { create(:eviction_file, :with_file, generated_at: Date.new(2024, 3, 13)) }
    let(:date_range) { EvictionLetter.calculate_dates(Date.current) }
    let(:eviction_file_no_file) { create(:eviction_file) }

    context 'when the file exists' do
      it 'attaches the file' do
        travel_to Date.new(2024, 3, 13) do
          mail = described_class.file_email(eviction_file.id, date_range)

          expect(mail.subject).to eq("Evictions File ID: #{eviction_file.id}")
          expect(mail.attachments[eviction_file.file.filename.to_s]).to be_present
        end
      end

      it 'sends the email' do
        travel_to Date.new(2024, 3, 13) do
          mail = described_class.file_email(eviction_file.id, date_range)

          expect { mail.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end
    end

    context 'when the file does not exist' do
      it 'does not send an email' do
        travel_to Date.new(2024, 3, 13) do
          mail = described_class.file_email(eviction_file_no_file.id, date_range)

          expect { mail.deliver_now }.to raise_error('No file attached to the EvictionFile')
        end
      end
    end
  end
end
