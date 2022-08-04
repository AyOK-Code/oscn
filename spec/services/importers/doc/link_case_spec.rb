require 'rails_helper'

RSpec.describe Importers::Doc::LinkCases do
  describe '#perform' do
    context 'when there are sentences/cases that match by case/crf number and name' do
      let!(:court_case) { create(:court_case) }
      let!(:sentence) { create(:doc_sentence, crf_number: court_case.case_number) }
      let!(:case_party) do
        create(:party, first_name: sentence.profile.first_name, last_name: sentence.profile.last_name)
      end

      it 'links the sentence to the case' do
        Importers::Doc::LinkCases.new(sentence.sentencing_county).perform
        expect(:sentence.court_case_id).to eq court_case.id
      end
    end
  end
end
