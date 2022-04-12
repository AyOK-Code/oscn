FactoryBot.define do
  factory :doc_historical_sentence, class: 'Doc::HistoricalSentence' do
    external_id { 1 }
    doc_profile { "" }
    order_id { "MyString" }
    charge_seq { "MyString" }
    crf_num { "MyString" }
    convict_date { "2022-04-12" }
    court { "MyString" }
    statute_code { "MyString" }
    offence_description { "MyString" }
    offence_comment { "MyString" }
    sentence_term_code { "MyString" }
    years { "MyString" }
    months { "MyString" }
    days { "MyString" }
    sentence_term { "MyString" }
    start_date { "2022-04-12" }
    end_date { "2022-04-12" }
    count_num { "MyString" }
    order_code { "MyString" }
    consecutive_to_count { "MyString" }
    charge_status { "MyString" }
  end
end
