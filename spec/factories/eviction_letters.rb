FactoryBot.define do
  factory :eviction_letter do
    status { 1 }
    docket_event_link { nil }
    ocr_plaintiff_address { 'MyString' }
    ocr_agreed_amount { 'MyString' }
    ocr_default_amount { 'MyString' }
    ocr_plaintiff_phone_number { 'MyString' }
    is_validated { false }
    validation_granularity { 'MyString' }
    validation_unconfirmed_components { 'MyString' }
    validation_inferred_components { 'MyString' }
    validation_usps_address { 'MyString' }
    validation_usps_state_zip { 'MyString' }
    validation_latitude { 1.5 }
    validation_longitude { 1.5 }
  end
end
