FactoryBot.define do
  factory :ok_sos_associated_entity, class: 'OkSos::AssociatedEntity' do
    associated_entity_id { Faker::Number.number(digits: 10) }
    capacity
  end
end
