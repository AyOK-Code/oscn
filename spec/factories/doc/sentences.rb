FactoryBot.define do
  factory :doc_sentence, class: 'Doc::Sentence' do
    doc_profile
    statute_code { 'MyString' }
    sentencing_county { 'MyString' }
    js_date { '2022-01-24' }
    crf_number { 'MyString' }
    incarcerated_term_in_years { '9.99' }
    probation_term_in_years { '9.99' }
  end
end
