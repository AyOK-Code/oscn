require 'rails_helper'

RSpec.shared_examples 'links successfully' do |_parameter|
  it 'links the sentence to the case' do
    described_class.new(sentence.sentencing_county).perform
    expect(sentence.reload.court_case_id).to eq court_case.id
  end
end

RSpec.shared_examples 'unlinked records' do |_parameter|
  it 'does not link the sentence to the case' do
    described_class.new(sentence.sentencing_county).perform
    expect(sentence.reload.court_case_id).not_to eq court_case.id
  end
end

RSpec.describe Importers::Doc::LinkCases do
  describe '#perform' do
    context 'when there are sentences/cases that match by case/crf number and name' do
      let!(:court_case) { create(:court_case) }
      let!(:sentence) { create(:doc_sentence, crf_number: court_case.case_number) }
      let!(:case_party) do
        create(:party, court_cases: [court_case], first_name: sentence.profile.first_name,
                       last_name: sentence.profile.last_name)
      end

      it_behaves_like 'links successfully'

      context 'when names are similar but not exact' do
        let!(:case_party) do
          create(:party, court_cases: [court_case], first_name: sentence.profile.first_name[1..],
                         last_name: sentence.profile.last_name)
        end

        it_behaves_like 'links successfully'
      end

      context 'when cases match by partial crf number' do
        context 'when there is no CF prefix (e.g., 2022-1234' do
          let!(:sentence) { create(:doc_sentence, crf_number: court_case.case_number[3..]) }
          it_behaves_like 'links successfully'
        end
        context 'when there is no CF prefix and only two digit year code (22-1234)' do
          let!(:sentence) { create(:doc_sentence, crf_number: court_case.case_number[5..]) }
          it_behaves_like 'links successfully'
        end
      end
    end

    context 'when there are sentences/cases with non matching crf/case numbers' do
      let!(:court_case) { create(:court_case) }
      let!(:sentence) { create(:doc_sentence) }
      let!(:case_party) do
        create(:party, court_cases: [court_case], first_name: sentence.profile.first_name,
                       last_name: sentence.profile.last_name)
      end

      it_behaves_like 'unlinked records'
    end

    context 'when there are sentences/cases with non matching names' do
      let!(:court_case) { create(:court_case) }
      let!(:sentence) { create(:doc_sentence, crf_number: court_case.case_number) }
      let!(:case_party) { create(:party, court_cases: [court_case]) }

      it_behaves_like 'unlinked records'
    end
  end
end
