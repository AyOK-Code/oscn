FactoryBot.define do
  factory :ok_election_voter, class: 'OkElection::Voter' do
    precinct { nil }
    last_name { "MyString" }
    first_name { "MyString" }
    middle_name { "MyString" }
    suffix { "MyString" }
    voter_id { 1 }
    political_affiliation { 1 }
    status { 1 }
    street_number { "MyString" }
    street_direction { "MyString" }
    street_name { "MyString" }
    street_type { "MyString" }
    building_number { "MyString" }
    city { "MyString" }
    zip_code { "MyString" }
    date_of_birth { "2023-12-10 21:36:45" }
    original_registration { "2023-12-10 21:36:45" }
  end
end
