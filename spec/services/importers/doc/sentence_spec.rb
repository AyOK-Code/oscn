require 'rails_helper'
require 'services/importers/doc/shared_specs'

RSpec.describe Importers::Doc::Sentence do
  it_behaves_like('doc_importer') do
    let(:class_to_import) { Doc::Sentence }
    let(:sample_file) do
      '0000010337000103370100121-701.7                      Bryan                                                       1920041320-15645                        82.67               3.00                '
    end
    let!(:profile) { create(:doc_profile, doc_number: '0000010337') }
    let(:expected_attributes) do
      {
        doc_profile_id: profile.id,
        sentence_id: '0001033701001',
        sentencing_county: 'Bryan',
        consecutive_to_sentence_id: nil,
        js_date: Date.parse('Tue, 13 Apr 1920'),
        crf_number: '20-15645',
        statute_code: '21-701.7',
        incarcerated_term_in_years: '82.67'.to_d,
        probation_term_in_years: '3.0'.to_d,
        is_death_sentence: false,
        is_life_sentence: false,
        is_life_no_parole_sentence: false
      }
    end
  end
end
