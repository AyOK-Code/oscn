require 'rails_helper'
require 'services/importers/ok_assessor/shared_specs'

RSpec.describe Importers::OkAssessor::Improvements do
  it_behaves_like 'ok_assessor_importer' do
    let!(:account) { create(:ok_assessor_account, account_num: 'R209117010') }
    let(:record) {
      OkAssessor::Improvement.find_by(account_id: account.id, building_num: 1)
    }
    let(:expected_attributes) do
      {
        account_id: account.id,
        building_num: 1,
        property_type: "Commercial",
        neighborhood_code: "1701",
        owner_occupied: nil,
        occupancy_code: "736",
        occupancy_description: "Ok City Airport & Misc Pub Trs",
        building_type: nil,
        square_feet: 1008,
        condominium_square_feet: nil,
        total_basement_square_feet: nil,
        finished_basement_square_feet: nil,
        garage_square_feet: nil,
        carport_square_feet: nil,
        balcony_square_feet: nil,
        porch_square_feet: nil,
        linear_feet_of_perimeter: 0.0,
        percent_complete: 100,
        condition: 'PR',
        quality: 'Fair',
        heat_vent_air_id: 5,
        heat_vent_air_description: 'Floor Wall Furnace',
        exterior: 'Frame Siding',
        interior: 'Plaster',
        unit_type: 'End',
        number_of_stories: 1.to_d,
        story_height: "1.5",
        square_feet_of_sprinkler_coverage: 15180,
        roof_type: 'Gable',
        roof_cover: 'Composition Shingle',
        floor_cover: 'Allowance',
        foundation_type: 'Conventional',
        number_of_rooms: 4,
        number_of_bedrooms: 1,
        number_of_bathrooms: 3,
        number_of_units: 1,
        type_of_construction_id: "1603",
        type_of_construction_description: 'Ranch 1 Story',
        year_built: 1906,
        year_remodeled: 2005,
        percent_remodeled: 0.0,
        adjusted_year_built: 1995,
        age: 25,
        mobilehome_title_number: "007747",
        mobilehome_serial_number: 'EMH0K14257BJ',
        mobilehome_length: 78,
        mobilehome_width: 14,
        mobilehome_make: 'Solitaire',
        improvement_value: 10607,
        new_construction_value_for_current_year: nil,
        new_growth_value_for_current_year: nil,
        building_permit_value: 2452,
        status: 'A'
      }
    end
  end
end
