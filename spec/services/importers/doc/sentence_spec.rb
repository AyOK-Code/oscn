require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Sentence do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { ::Doc::Sentence }
    let(:sample_file) do
      ' 0000704102440992-5                                21-1283                                 TULSA COUNTY COURT                      20210930CF-2021-3456                                          000000003.00'
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000704102') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        sentence_id: '440992-5',
        sentencing_county: 'TULSA COUNTY COURT',
        consecutive_to_sentence_id: '',
        js_date: Date.parse('Thu, 30 Sep 2021'),
        crf_number: 'CF-2021-3456',
        statute_code: '21-1283',
        incarcerated_term_in_years: 0.0,
        probation_term_in_years: 3,
        is_death_sentence: false,
        is_life_sentence: false,
        is_life_no_parole_sentence: false
      }
    end
  end
end
