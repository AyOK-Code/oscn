FactoryBot.define do
  factory :ok_assessor_improvement, class: 'OkAssessor::Improvement' do
    association :account, factory: :ok_assessor_account
  end
end
