class AddDistrictAttorneyToCounties < ActiveRecord::Migration[6.0]
  def change
    add_reference :counties, :district_attorney, index: true
  end
end
