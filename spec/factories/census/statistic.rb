FactoryBot.define do
  factory :statistic, class: 'Census::Statistic' do
    association :survey
    name { Faker::Lorem.word }
    label { "#{Faker::Lorem.word}::#{Faker::Lorem.word}::#{Faker::Lorem.word}" }
    concept { Faker::Lorem.sentence }
    group { Faker::String.random(length: 4).upcase }
    predicate_type { %w[long float string].sample }
  end
end
