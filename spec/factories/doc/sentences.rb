FactoryBot.define do
  factory :doc_sentence, class: 'Doc::Sentence' do
    profile { association :doc_profile }
    statute_code { 'MyString' }
    sentencing_county { 'MyString' }
    js_date { '2022-01-24' }
    crf_number { 'MyString' }
    incarcerated_term_in_years { '9.99' }
    probation_term_in_years { '9.99' }
    sentence_id { Faker::Number.number(digits: 10) }
  end
end
