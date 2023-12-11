FactoryBot.define do
  factory :ok_election_precinct, class: 'OkElection::Precinct' do
    county { nil }
    code { 1 }
    congressional_district { 1 }
    state_senate_district { 1 }
    state_house_district { 1 }
    county_commisioner { 1 }
    poll_site { "MyString" }
  end
end
