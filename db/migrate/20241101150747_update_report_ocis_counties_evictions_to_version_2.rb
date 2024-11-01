class UpdateReportOcisCountiesEvictionsToVersion2 < ActiveRecord::Migration[7.0]
  def change
    update_view :report_ocis_counties_evictions,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end
