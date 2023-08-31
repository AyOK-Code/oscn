FactoryBot.define do
  factory :tulsa_blotter_offense, class: TulsaBlotter::Offense do
    arrest { nil }
  end
end
