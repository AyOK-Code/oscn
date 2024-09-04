FactoryBot.define do
  factory :ok_assessor_account, class: 'OkAssessor::Account' do
    account_num { Faker::Lorem.word }
  end
end
