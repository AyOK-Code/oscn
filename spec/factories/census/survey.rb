FactoryBot.define do
  factory :survey, class: 'Census::Survey' do
    year { (2010..2022).to_a.sample }
    name { [Census::Survey::ACS1, Census::Survey::ACS5].sample }
  end
end
