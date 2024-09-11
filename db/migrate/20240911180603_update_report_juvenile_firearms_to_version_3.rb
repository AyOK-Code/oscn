class UpdateReportJuvenileFirearmsToVersion3 < ActiveRecord::Migration[7.0]
  def change
    # Ensure pg_trgm extension is enabled
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')

    update_view :report_juvenile_firearms, version: 3, revert_to_version: 2
  end
end
