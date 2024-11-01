class CreateReportOcisCountiesEvictions < ActiveRecord::Migration[7.0]
  def change
    create_view :report_ocis_counties_evictions, materialized: true

    add_index :report_ocis_counties_evictions, :county_id
    add_index :report_ocis_counties_evictions, :court_case_id
    add_index :report_ocis_counties_evictions, :case_filed_on
    add_index :report_ocis_counties_evictions, :case_closed_on
  end
end
