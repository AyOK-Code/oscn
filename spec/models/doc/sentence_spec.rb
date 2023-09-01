require 'rails_helper'

RSpec.describe Doc::Sentence, type: :model do
  describe 'associations' do
    it { should belong_to(:profile).class_name('Doc::Profile') }
    it { should belong_to(:offense_code).class_name('Doc::OffenseCode').optional }
  end
  describe 'generated clean_case_number column' do
    before(:all) do
      @doc_profile = create(:doc_profile)
      
    end
    context 'when crf_number matches' do
      context 'when format ^[A-Za-z]{2}[0-9]{5,}' do
        it 'parses the crf_number' do
          
          doc_sentence = create(:doc_sentence, crf_number: 'CF94008641',doc_profile_id:@doc_profile.id,sentence_id:1,id:1)
          doc_sentence.reload
          expect(doc_sentence.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' do
        it 'parses the crf_number' do
          doc_sentence = create(:doc_sentence, crf_number: 'CF-94-8641',doc_profile_id:@doc_profile.id,sentence_id:2,id:2)
          doc_sentence.reload
          expect(doc_sentence.clean_case_number).to eq 'CF-1994-8641'
        end
      end

      context 'when format ^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' do
        it 'parses the crf_number' do
          doc_sentence = create(:doc_sentence, crf_number: 'CF-1994-8641',doc_profile_id:@doc_profile.id,sentence_id:3,id:3)
          doc_sentence.reload
          expect(doc_sentence.clean_case_number).to eq 'CF-1994-8641'
        end
      end
    end
    context 'when crf_number does not match' do
      it 'is null' do
        doc_sentence = create(:doc_sentence, crf_number: 'ABC-19991-0',doc_profile_id:@doc_profile.id,sentence_id:4,id:4)
        doc_sentence.reload
        expect(doc_sentence.clean_case_number).to be nil
      end
    end
  end
end
